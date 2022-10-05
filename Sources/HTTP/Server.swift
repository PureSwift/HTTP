//
//  HTTPServer.swift
//  
//
//  Created by Alsey Coleman Miller on 10/3/22.
//

import Foundation
import Socket

public final class HTTPServer {
    
    // MARK: - Properties
    
    public let configuration: Configuration
    
    internal let response: (IPAddress, HTTPRequest) async -> (HTTPResponse)
    
    internal let log: ((String) -> ())?
    
    internal let socket: Socket
    
    private var task: Task<(), Never>?
    
    let storage = Storage()
    
    // MARK: - Initialization
    
    deinit {
        stop()
    }
    
    public init(
        configuration: Configuration = .init(),
        log: ((String) -> ())? = nil,
        response: ((IPAddress, HTTPRequest) async -> HTTPResponse)? = nil
    ) async throws {
        #if DEBUG
        let log = log ?? {
            NSLog("HTTPServer: \($0)")
        }
        #endif
        self.configuration = configuration
        self.log = log
        self.response = response ?? { (address, request) in
            #if DEBUG
            log("[\(address)] \(request.method) \(request.uri)")
            #endif
            return .init(code: .ok)
        }
        // create listening socket
        self.socket = try await Socket(.tcp, bind: IPv4SocketAddress(address: .any, port: configuration.port))
        try socket.fileDescriptor.listen(backlog: configuration.backlog)
        // start running server
        start()
    }
    
    // MARK: - Methods
    
    private func start() {
        assert(task == nil)
        // listening run loop
        self.task = Task.detached(priority: .high) { [weak self] in
            self?.log?("Started HTTP Server")
            do {
                while let socket = self?.socket {
                    // wait for incoming sockets
                    let newSocket = try await Socket(fileDescriptor: socket.fileDescriptor.accept())
                    // read remote address
                    let address = try newSocket.fileDescriptor.peerAddress(IPv4SocketAddress.self).address // TODO: Support IPv6
                    if let self = self {
                        self.log?("[\(address)] New connection")
                        let connection = await Connection(address: .v4(address), socket: newSocket, server: self)
                        await self.storage.newConnection(connection)
                    }
                }
            }
            catch _ as CancellationError { }
            catch {
                self?.log?("Error waiting for new connection: \(error)")
            }
        }
    }
    
    public func stop() {
        assert(task != nil)
        let socket = self.socket
        let storage = self.storage
        self.task?.cancel()
        self.task = nil
        self.log?("Stopped GATT Server")
        Task {
            await storage.removeAllConnections()
            await socket.close()
        }
    }
}

internal extension HTTPServer {
    
    func connection(_ address: IPAddress, didDisconnect error: Swift.Error?) async {
        // remove connection cache
        await storage.removeConnection(address)
        // log
        log?("[\(address)]: " + "Did disconnect. \(error?.localizedDescription ?? "")")
    }
}

// MARK: - Supporting Types

public extension HTTPServer {
    
    struct Configuration: Equatable, Hashable, Codable {
        
        public let port: UInt16
                
        public let backlog: Int
        
        public let headerMaxSize: Int
        
        public let bodyMaxSize: Int
        
        public init(
            port: UInt16 = 8080,
            backlog: Int = 10_000,
            headerMaxSize: Int = 4096,
            bodyMaxSize: Int = 1024 * 1024 * 10
        ) {
            self.port = port
            self.backlog = backlog
            self.headerMaxSize = headerMaxSize
            self.bodyMaxSize = bodyMaxSize
        }
    }
}

internal extension HTTPServer {
    
    actor Storage {
        
        var connections = [IPAddress: Connection](minimumCapacity: 100)
        
        fileprivate init() { }
        
        func newConnection(_ connection: Connection) {
            connections[connection.address] = connection
        }
        
        func removeConnection(_ address: IPAddress) {
            self.connections[address] = nil
        }
        
        func removeAllConnections() {
            self.connections.removeAll()
        }
    }
}

internal extension HTTPServer {
    
    actor Connection {
        
        // MARK: - Properties
        
        let address: IPAddress
        
        let socket: Socket
        
        private unowned var server: HTTPServer
        
        let configuration: Configuration
        
        private(set) var isConnected = true
        
        private(set) var readData = Data()
        
        // MARK: - Initialization
        
        deinit {
            let socket = self.socket
            Task { await socket.close() }
        }
        
        init(
            address: IPAddress,
            socket: Socket,
            server: HTTPServer
        ) async {
            self.address = address
            self.socket = socket
            self.server = server
            self.configuration = server.configuration
            await run()
        }
        
        private func run() {
            // start reading
            Task {
                await run()
            }
            Task.detached(priority: .high) { [weak self] in
                guard let stream = self?.socket.event else { return }
                for await event in stream {
                    await self?.socketEvent(event)
                }
                // socket closed
            }
        }
        
        private func socketEvent(_ event: Socket.Event) async {
            switch event {
            case .pendingRead:
                break
            case .read:
                break
            case .write:
                break
            case let .close(error):
                isConnected = false
                await server.connection(address, didDisconnect: error)
            }
        }
        
        private func read(_ length: Int) async throws {
            let chunkSize = 536 // The default TCP Maximum Segment Size is 536
            var readLength = 0
            var readMore = true
            while readMore {
                let chunk = try await socket.read(chunkSize)
                readLength += chunk.count
                self.readData.append(chunk)
                readMore = readLength < length && chunk.count == chunkSize // need more data and read max
            }
            self.server.log?("[\(address)] Read \(readLength) bytes")
        }
        
        private func respond(_ response: HTTPResponse) async throws {
            let chunkSize = 536 // The default TCP Maximum Segment Size is 536
            let data = response.data
            self.server.log?("[\(address)] Response \(response.code.rawValue) \(response.status) \(response.body.count) bytes")
            try await socket.write(data)
            await socket.close()
        }
        
        private func respond(_ code: HTTPStatusCode) async throws {
            try await respond(HTTPResponse(code: code))
        }
        
        private func run() async {
            let headerMaxSize = configuration.headerMaxSize
            let initialReadSize = max(min(headerMaxSize, 512), 5)
            do {
                // read small chunk
                try await read(initialReadSize)
                // read remaning
                if initialReadSize < headerMaxSize,
                   readData.count < headerMaxSize,
                   readData.firstRange(of: HTTPMessage.Decoder.headerSuffixData) == nil {
                    let remainingSize = readData.count - headerMaxSize
                    try await read(remainingSize)
                }
                // verify header
                guard let headerEndIndex = readData.firstRange(of: HTTPMessage.Decoder.headerSuffixData)?.endIndex else {
                    try await respond(.payloadTooLarge)
                    return
                }
                guard var request = HTTPRequest(data: readData) else {
                    try await respond(.badRequest)
                    return
                }
                // get body
                if let contentLength = request.headers[.contentLength].flatMap(Int.init), contentLength > 0 {
                    guard contentLength <= configuration.bodyMaxSize else {
                        try await respond(.payloadTooLarge)
                        return
                    }
                    let targetSize = headerEndIndex + contentLength
                    let remainder = targetSize - readData.count
                    if remainder > 0 {
                        try await read(remainder)
                    }
                    request.body = readData.suffix(contentLength)
                } else {
                    request.body = Data()
                }
                self.server.log?("[\(address)] \(request.method) \(request.uri) \(request.body.count) bytes")
                // respond
                let response = await self.server.response(address, request)
                try await respond(response)
            } catch {
                self.server.log?("[\(address)] \(error.localizedDescription)")
                await self.socket.close()
            }
        }
    }
}
