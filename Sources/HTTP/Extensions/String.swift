//
//  String.swift
//  HTTP
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

import Foundation

internal extension String {
    
    var isASCII: Bool {
        self.utf8.allSatisfy { $0 & 0x80 == 0 }
    }
}
