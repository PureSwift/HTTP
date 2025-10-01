//
//  HTTPTypes.swift
//  HTTP
//
//  Created by Alsey Coleman Miller on 10/1/25.
//

#if canImport(HTTPTypesFoundation)
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import HTTPTypes
import HTTPTypesFoundation

public extension URLRequest {
    
    init?(_ request: HTTPRequest, baseURL: URL) {
        guard var baseUrlComponents = URLComponents(string: baseURL.absoluteString),
            let requestUrlComponents = URLComponents(string: request.path ?? "")
        else {
            return nil
        }
        let path = requestUrlComponents.percentEncodedPath
        baseUrlComponents.percentEncodedPath += path
        baseUrlComponents.percentEncodedQuery = requestUrlComponents.percentEncodedQuery
        guard let url = baseUrlComponents.url else {
            return nil
        }
        self.init(url: url)
        self.httpMethod = request.method.rawValue
        var combinedFields = [HTTPField.Name: String](minimumCapacity: request.headerFields.count)
        for field in request.headerFields {
            if let existingValue = combinedFields[field.name] {
                let separator = field.name == .cookie ? "; " : ", "
                combinedFields[field.name] = "\(existingValue)\(separator)\(field.isoLatin1Value)"
            } else {
                combinedFields[field.name] = field.isoLatin1Value
            }
        }
        var headerFields = [String: String](minimumCapacity: combinedFields.count)
        for (name, value) in combinedFields { headerFields[name.rawName] = value }
        self.allHTTPHeaderFields = headerFields
    }
}

public extension HTTPResponse {
    
    init?(_ urlResponse: URLResponse) {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return nil
        }
        guard (0...999).contains(httpResponse.statusCode) else {
            return nil
        }
        self.init(status: .init(code: httpResponse.statusCode))
        if let fields = httpResponse.allHeaderFields as? [String: String] {
            self.headerFields.reserveCapacity(fields.count)
            for (name, value) in fields {
                if let name = HTTPField.Name(name) {
                    self.headerFields.append(HTTPField(name: name, isoLatin1Value: value))
                }
            }
        }
    }
}
#endif

internal extension HTTPField {
    
    init(name: Name, isoLatin1Value: String) {
        if isoLatin1Value.isASCII {
            self.init(name: name, value: isoLatin1Value)
        } else {
            self = withUnsafeTemporaryAllocation(of: UInt8.self, capacity: isoLatin1Value.unicodeScalars.count) {
                buffer in
                for (index, scalar) in isoLatin1Value.unicodeScalars.enumerated() {
                    if scalar.value > UInt8.max {
                        buffer[index] = 0x20
                    } else {
                        buffer[index] = UInt8(truncatingIfNeeded: scalar.value)
                    }
                }
                return HTTPField(name: name, value: buffer)
            }
        }
    }

    var isoLatin1Value: String {
        if self.value.isASCII { return self.value }
        return self.withUnsafeBytesOfValue { buffer in
            let scalars = buffer.lazy.map { UnicodeScalar(UInt32($0))! }
            var string = ""
            string.unicodeScalars.append(contentsOf: scalars)
            return string
        }
    }
}
