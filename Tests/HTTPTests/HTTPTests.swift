//
//  HTTPTests.swift
//  PureSwift
//
//  Created by Alsey Coleman Miller on 8/28/17.
//  Copyright © 2017 PureSwift. All rights reserved.
//

import Foundation
import XCTest
import HTTP

final class HTTPTests: XCTestCase {
    
    func testVersion() {
        XCTAssertEqual(HTTPVersion.v1.rawValue, "HTTP/1.0")
        XCTAssertEqual(HTTPVersion(rawValue: "HTTP/1.0"), .v1)
        XCTAssertEqual(HTTPVersion.v1_1.rawValue, "HTTP/1.1")
        XCTAssertEqual(HTTPVersion(rawValue: "HTTP/1.1"), .v1_1)
        XCTAssertEqual(HTTPVersion.v2.rawValue, "HTTP/2.0")
        XCTAssertEqual(HTTPVersion(rawValue: "HTTP/2.0"), .v2)
    }
}
