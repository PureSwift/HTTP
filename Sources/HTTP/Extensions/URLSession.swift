//
//  URLSession.swift
//  HTTP
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTPTypes

extension URLSession: URLClient {
    
    public func data(
        for request: URLRequest
    ) async throws(Foundation.URLError) -> (Data, URLResponse) {
        do {
            #if canImport(Darwin)
            if #available(macOS 12, iOS 15.0, tvOS 15, watchOS 8, *) {
                return try await self.data(for: request, delegate: nil)
    
            } else {
                return try await _data(for: request)
            }
            #else
            return try await _data(for: request)
            #endif
        }
        catch {
            guard let urlError = error as? Foundation.URLError else {
                assertionFailure("Invalid error \(error)")
                throw URLError(.unknown)
            }
            throw urlError
        }
    }
}

internal extension URLSession {
    
    func _data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (data ?? .init(), response!))
                }
            }
            task.resume()
        }
    }
}

#if canImport(HTTPTypesFoundation)
import HTTPTypesFoundation

extension URLSession: HTTPClient { }
#endif
