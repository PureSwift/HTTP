//
//  HTTP.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import struct Foundation.URL

public struct HTTP {
        
    public static func validate(url: URL) -> Bool {
        
        guard (url.scheme == "http" ||  url.scheme == "https") else { return false }
        
        return true
    }
}
