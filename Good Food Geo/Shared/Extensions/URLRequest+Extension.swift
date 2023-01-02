//
//  URLRequest+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import Foundation

extension URLRequest {
    // MARK: - Body
    mutating func setBody(_ body: [String: String]) {
        if let body = try? JSONSerialization.data(withJSONObject: body) {
            httpBody = body
        }
    }

    // MARK: - Method
    mutating func setMethod(_ method: URLRequest.Method) {
        httpMethod = method.title
    }

    enum Method: String {
        case get
        case post

        var title: String {
            rawValue.uppercased()
        }
    }

    // MARK: - Content Type
    mutating func setContentType(_ contentType: ContentType) {
        addValue(contentType.title, forHTTPHeaderField: "Content-Type")
    }

    enum ContentType: String {
        case applicationJson = "application/json"

        var title: String {
            rawValue
        }
    }
}
