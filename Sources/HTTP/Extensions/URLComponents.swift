//
//  URLComponents.swift
//  HTTP
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal extension URLComponents {
    
    static func appending(
        queryItems: [URLQueryItem],
        to url: URL
    ) -> URL {
        guard queryItems.isEmpty == false else {
            return url
        }
        guard var components = URLComponents(string: url.absoluteString) else {
            assertionFailure()
            return url
        }
        components.queryItems = queryItems
        guard let newURL = components.url else {
            assertionFailure()
            return url
        }
        return newURL
    }
}
