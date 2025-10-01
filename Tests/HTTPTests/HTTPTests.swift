//
//  HTTPTests.swift
//  PureSwift
//
//  Created by Alsey Coleman Miller on 8/28/17.
//  Copyright © 2017 PureSwift. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import HTTP

@Suite
struct HTTPTests {
    
    @Test
    func version() {
        #expect(HTTPVersion.v1.rawValue == "HTTP/1.0")
        #expect(HTTPVersion(rawValue: "HTTP/1.0") == .v1)
        #expect(HTTPVersion.v1_1.rawValue == "HTTP/1.1")
        #expect(HTTPVersion(rawValue: "HTTP/1.1") == .v1_1)
        #expect(HTTPVersion.v2.rawValue == "HTTP/2.0")
        #expect(HTTPVersion(rawValue: "HTTP/2.0") == .v2)
    }
}
