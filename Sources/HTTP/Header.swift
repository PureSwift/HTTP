//
//  Header.swift
//  
//
//  Created by Alsey Coleman Miller on 10/2/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@_exported import HTTPTypes
#if canImport(HTTPTypesFoundation)
import HTTPTypesFoundation
#endif

public protocol HTTPHeader {
    
    static var httpHeaderName: HTTPTypes.HTTPField.Name { get }
    
    var httpHeaderValue: String { get }
}

extension HTTPHeader where Self: RawRepresentable, RawValue == String {
    
    public var httpHeaderValue: String {
        rawValue
    }
}

public extension HTTPField {
    
    init<T: HTTPHeader>(header: T) {
        self.init(name: T.httpHeaderName, value: header.httpHeaderValue)
    }
}

#if canImport(HTTPTypesFoundation)
public extension URLRequest {
    
    mutating func setHeader<T: HTTPHeader>(_ header: T) {
        let field = HTTPField(header: header)
        self.setValue(field.value, forHTTPHeaderField: field.name.rawName)
    }
}
#endif

public extension HTTPRequest {
    
    mutating func setHeader<T: HTTPHeader>(_ header: T) {
        let field = HTTPField(header: header)
        self.headerFields[field.name] = field.value
    }
}

public extension HTTPFields {
    
    init(headers: [any HTTPHeader]) {
        self.init()
        for header in headers {
            self[type(of: header).httpHeaderName] = header.httpHeaderValue
        }
    }
}
