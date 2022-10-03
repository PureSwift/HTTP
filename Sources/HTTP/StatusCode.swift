//
//  HTTPStatusCode.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// HTTP Status Code
public struct HTTPStatusCode: RawRepresentable, Codable, Equatable, Hashable {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension HTTPStatusCode: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension HTTPStatusCode: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        rawValue.description
    }
    
    public var debugDescription: String {
        rawValue.description
    }
}

// MARK: - Definitions

public extension HTTPStatusCode {
    
    // MARK: - 1xx Informational
    
    /// Continue
    ///
    /// This means that the server has received the request headers,
    /// and that the client should proceed to send the request body
    /// (in the case of a request for which a body needs to be sent; for example, a POST request).
    /// If the request body is large, sending it to a server when a request has already been rejected
    /// based upon inappropriate headers is inefficient.
    /// To have a server check if the request could be accepted based on the request's headers alone,
    /// a client must send Expect: 100-continue as a header in its initial request and check if a 100
    /// Continue status code is received in response before continuing
    /// (or receive 417 Expectation Failed and not continue).
    static var `continue`: HTTPStatusCode               { 100 }
    
    /// Switching Protocols
    ///
    /// This means the requester has asked the server to switch protocols and the server
    /// is acknowledging that it will do so.
    static var switchingProtocols: HTTPStatusCode       { 101 }
    
    /// Processing (WebDAV; RFC 2518)
    ///
    /// As a WebDAV request may contain many sub-requests involving file operations,
    /// it may take a long time to complete the request.
    /// This code indicates that the server has received and is processing the request,
    /// but no response is available yet.
    /// This prevents the client from timing out and assuming the request was lost.
    static var processing: HTTPStatusCode               { 102 }
    
    // MARK: - 2xx Success
    
    /// OK
    ///
    /// Standard response for successful HTTP requests.
    /// The actual response will depend on the request method used.
    /// In a GET request, the response will contain an entity corresponding to the requested resource.
    /// In a POST request, the response will contain an entity describing or containing
    /// the result of the action.
    static var ok: HTTPStatusCode                       { 200 }
    
    /// Created
    ///
    /// The request has been fulfilled and resulted in a new resource being created.
    static var created: HTTPStatusCode                  { 201 }
    
    /// Accepted
    ///
    /// The request has been accepted for processing, but the processing has not been completed.
    /// The request might or might not eventually be acted upon,
    /// as it might be disallowed when processing actually takes place.
    static var accepted: HTTPStatusCode                 { 202 }
    
    // MARK: - 5xx Server Error
    
    /// Internal Server Error
    ///
    /// A generic error message, given when an unexpected condition was encountered and
    /// no more specific message is suitable.
    static var internalServerError: HTTPStatusCode      { 500 }
}
