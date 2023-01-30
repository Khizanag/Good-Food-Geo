//
//  Endpoint.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

enum EndPoint {
    case registration
    case login
    case userInformation
    case products
    case resetLink
    case googleAuthentication
    case facebookAuthentication
    case verifyRegistration
    case feed
    case deleteAccount
}

extension EndPoint {
    var relativePath: String {
        switch self {
        case .registration:
            return "register"
        case .login:
            return "login"
        case .userInformation:
            return "profile"
        case .resetLink:
            return "reset-link"
        case .googleAuthentication:
            return "google"
        case .facebookAuthentication:
            return "facebook"
        case .verifyRegistration:
            return "verify-registration"
        case .feed:
            return "feed"
        case .products:
            return "products"
        case .deleteAccount:
            return "delete-user"
        }
    }

    var fullPath: String {
        NetworkConstant.baseUrl + relativePath + "/"
    }

    var fullUrl: URL {
        URL(string: fullPath)!
    }
}
