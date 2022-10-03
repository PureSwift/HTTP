//
//  HTTPTests.swift
//  PureSwift
//
//  Created by Alsey Coleman Miller on 8/28/17.
//  Copyright © 2017 PureSwift. All rights reserved.
//

import Foundation
import XCTest
@testable import HTTP

final class HTTPTests: XCTestCase {
    
    func testVersion() {
        XCTAssertEqual(HTTPVersion.v1.rawValue, "HTTP/1.0")
        XCTAssertEqual(HTTPVersion(rawValue: "HTTP/1.0"), .v1)
        XCTAssertEqual(HTTPVersion.v1_1.rawValue, "HTTP/1.1")
        XCTAssertEqual(HTTPVersion(rawValue: "HTTP/1.1"), .v1_1)
        XCTAssertEqual(HTTPVersion.v2.rawValue, "HTTP/2.0")
        XCTAssertEqual(HTTPVersion(rawValue: "HTTP/2.0"), .v2)
    }
    /*
    func testMessage() {
        
        let string = """
        HTTP/1.1 200 OK
        Date: Sun, 10 Oct 2010 23:26:07 GMT
        Server: Apache/2.2.8 (Ubuntu) mod_ssl/2.2.8 OpenSSL/0.9.8g
        Last-Modified: Sun, 26 Sep 2010 22:04:35 GMT
        ETag: "45b6-834-49130cc1182c0"
        Accept-Ranges: bytes
        Content-Length: 12
        Connection: close
        Content-Type: text/html

        Hello world!
        """
        
        guard let message = HTTPMessage(data: Data(string.utf8)) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(message.body, Data("Hello world!".utf8))
        XCTAssertEqual(message.headers[.date], "Sun, 10 Oct 2010 23:26:07 GMT")
        XCTAssertEqual(message.headers[.contentType], "text/html")
        XCTAssertEqual(message.headers.count, 8)
        XCTAssertEqual(message.head, .response(.init(version: .v1_1, code: .ok)))
    }*/
    
    func testRequestHeader() {
        let string = #"GET /logo.gif HTTP/1.1"#
        guard let header = HTTPMessage.Header.Request(rawValue: string) else {
            XCTFail()
            return
        }
        XCTAssertEqual(header.method, .get)
        XCTAssertEqual(header.uri, "/logo.gif")
        XCTAssertEqual(header.version, .v1_1)
        XCTAssertEqual(HTTPMessage.Header(rawValue: string), .request(header))
    }
    
    func testResponseHeader() {
        let string = #"HTTP/1.1 200 OK"#
        guard let header = HTTPMessage.Header.Response(rawValue: string) else {
            XCTFail()
            return
        }
        XCTAssertEqual(header.version, .v1_1)
        XCTAssertEqual(header.code, .ok)
        XCTAssertEqual(header.status, header.code.reasonPhrase)
        XCTAssertEqual(HTTPMessage.Header(rawValue: string), .response(header))
    }
}
