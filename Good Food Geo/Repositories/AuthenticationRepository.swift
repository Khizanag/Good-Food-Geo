//
//  AuthenticationRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 17.01.23.
//

import Foundation

protocol AuthenticationRepository {
    func authenticateUsingApple(with userId: String) async -> Result<AppleAuthenticationResponse, AppError>
    func authenticateUsingFacebook(with token: String) async -> Result<SocialNetworkAuthenticationResponse, AppError>
    func authenticateUsingGoogle(with token: String) async -> Result<SocialNetworkAuthenticationResponse, AppError>
}

struct DefaultAuthenticationRepository: AuthenticationRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func authenticateUsingApple(with userId: String) async -> Result<AppleAuthenticationResponse, AppError> {
        var request = URLRequest(url: EndPoint.appleAuthentication.fullUrl)
        request.setMethod(.put)
        request.setContentType(.applicationJson)
        request.setBody([
            "apple_user_id": userId
        ])

        return await networkLayer.execute(AppleAuthenticationResponse.self, using: request)
    }

    func authenticateUsingFacebook(with token: String) async -> Result<SocialNetworkAuthenticationResponse, AppError> {
        await authenticate(using: .facebook, with: token)
    }

    func authenticateUsingGoogle(with token: String) async -> Result<SocialNetworkAuthenticationResponse, AppError> {
        await authenticate(using: .google, with: token)
    }
}

// MARK: - Private
private extension DefaultAuthenticationRepository {
    func authenticate(using socialNetwork: AuthenticatingSocialNetwork, with token: String) async -> Result<SocialNetworkAuthenticationResponse, AppError> {
        var request = URLRequest(url: socialNetwork.endpointUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "auth_token": token
        ])

        return await networkLayer.execute(SocialNetworkAuthenticationResponse.self, using: request)
    }
}

enum AuthenticatingSocialNetwork {
    case facebook
    case google

    var endpointUrl: URL {
        switch self {
        case .facebook:
            return EndPoint.facebookAuthentication.fullUrl
        case .google:
            return EndPoint.googleAuthentication.fullUrl
        }
    }
}
