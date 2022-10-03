//
//  Message.swift
//  
//
//  Created by Alsey Coleman Miller on 10/2/22.
//

import Foundation

/// HTTP Message
public struct HTTPMessage {} /*: Equatable, Hashable, Sendable {
    
    public var head: Header
    
    public var headers: [(HTTPHeader, String)]
    
    public var body: Data
}*/

public extension HTTPMessage {
    
    init?(data: Data) {
        fatalError()
    }
}

// MARK: - Header



// MARK: - Constants

internal extension HTTPMessage {
    
    static var crlf: StaticString { "\r\n" }
    
    static var headerSeparator: StaticString { ": " }
    
    static var headSeparator: String { " " }
}
