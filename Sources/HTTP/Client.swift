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

extension URLSession: HTTPClient { }
