//
//  HTTPResponse.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

/// HTTP URL response.
public struct HTTPResponse {
    
    /// Returns a dictionary containing all the HTTP header fields.
    public var headers: [HTTPHeader: String]
    
    /// Returns the HTTP status code for the response.
    public var statusCode: Int
    
    /// The HTTP response body.
    public var body: Data
    
    /// The URL for the response.
    ///
    /// Returned with 302 Found response.
    public var url: URL?
}
