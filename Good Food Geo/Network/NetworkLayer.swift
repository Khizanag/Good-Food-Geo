//
//  NetworkLayer.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import Foundation

// MARK: - Protocol
protocol NetworkLayer {
    func execute<T>(_ type: T.Type, using request: URLRequest) async -> T? where T: Decodable
}

// MARK: - Implementation
final class DefaultNetworkLayer: NetworkLayer {
    func execute<T>(_ type: T.Type, using request: URLRequest) async -> T? where T: Decodable {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }

            let decoder = JSONDecoder()
            let responseObject = try decoder.decode(type, from: data)
            return responseObject
        } catch {
            // Error handling in case the data couldn't be loaded
            // For now, only display the error on the console
            debugPrint("Error loading: \(String(describing: error))")
            return nil
        }
    }
}

enum NetworkConstant {
    static let baseUrl = "https://web-production-eff5.up.railway.app/"
}

enum EndPoint {
    case registration           // -
    case login                  // +
    case userInformation        // -
    case resetLink              // -
    case googleAuthentication   // -
    case facebookAuthentication // -
    case verifyRegistration     // -
    case feed                   // +
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
        }
    }

    var fullPath: String {
        NetworkConstant.baseUrl + relativePath + "/"
    }

    var fullUrl: URL {
        URL(string: fullPath)!
    }
}
