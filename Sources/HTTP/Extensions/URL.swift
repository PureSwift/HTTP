//
//  URL.swift
//  HTTP
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension URL {
    
    func appending(_ queryItems: URLQueryItem?...) -> URL {
        let items = queryItems.compactMap({ $0 })
        return appending(items)
    }
    
    func appending(_ queryItems: [URLQueryItem]) -> URL {
        guard queryItems.isEmpty == false else {
            return self
        }
        #if canImport(FoundationNetworking)
        return appending(queryItems: queryItems)
        #else
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return appending(queryItems: queryItems)
        } else {
            return URLComponents.appending(queryItems: queryItems, to: self)
        }
        #endif
    }
    
    mutating func append(_ queryItems: [URLQueryItem]) {
        guard queryItems.isEmpty == false else {
            return
        }
        #if canImport(FoundationNetworking)
        append(queryItems: queryItems)
        #else
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            append(queryItems: queryItems)
        } else {
            self = URLComponents.appending(queryItems: queryItems, to: self)
        }
        #endif
    }
}
