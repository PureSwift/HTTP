//
//  HTTPRequest.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

/// HTTP URL Request.
public struct HTTPRequest {
    
    public var url: URL
    
    public var timeoutInterval: TimeInterval
    
    public var body: Data
    
    public var headers: [HTTPHeader: String]
}
