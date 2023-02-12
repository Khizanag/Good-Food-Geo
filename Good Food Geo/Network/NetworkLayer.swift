//
//  NetworkLayer.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import Foundation

// MARK: - Protocol
protocol NetworkLayer {
    func execute<T>(_ type: T.Type, using request: URLRequest) async -> Result<T, AppError> where T: Decodable
}

// MARK: - Implementation
final class DefaultNetworkLayer: NetworkLayer {
    func execute<T>(_ type: T.Type, using request: URLRequest) async -> Result<T, AppError> where T: Decodable {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            #if DEBUG
            debugPrint("********Data: \(data)", String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            #endif

            guard let httpResponse = response as? HTTPURLResponse else { return .failure(.general)}

            debugPrint("Status code: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else { return .failure(.wrongStatusCode) }

            let decoder = JSONDecoder()
            let responseObject = try decoder.decode(type, from: data)
            return .success(responseObject)
        } catch {
            // Error handling in case the data couldn't be loaded
            // For now, only display the error on the console
            debugPrint("Error loading: \(String(describing: error))")
            return .failure(.parsing)
        }
    }
}

enum NetworkConstant {
    static let baseUrl = "https://" + "web-production-eff5.up.railway.app/"
}
