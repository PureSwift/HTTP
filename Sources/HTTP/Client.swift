//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 9/02/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// HTTP Client
public protocol HTTPClient {
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

@available(macOS 12.0, *)
extension URLSession: HTTPClient {
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request, delegate: nil)
    }
}
