//
//  AuthenticationRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 31.12.22.
//

import Foundation

protocol Repository {
    func login(email: String, password: String) async -> LoginResponse?
    func register(email: String, name: String, password: String, phoneNumber: String) async -> RegistrationResponse?
    func authenticateViaGoogle(token: String) async
    func authenticateViaFacebook(token: String) async
    func verifyRegistration(email: String, code: String) async -> VerificationEntity?

    func resetPassword(email: String) async -> PasswordResetEntity?

    func getUserInformation(using token: String) async -> UserInformationEntity?
}

struct DefaultRepository: Repository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func login(email: String, password: String) async -> LoginResponse? {
        var request = URLRequest(url: EndPoint.login.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email,
            "password": password
        ])

        return await networkLayer.execute(LoginResponse.self, using: request)
    }

    func register(email: String, name: String, password: String, phoneNumber: String) async -> RegistrationResponse? {
        var request = URLRequest(url: EndPoint.registration.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email,
            "password": password,
            "name": name,
            "phone_number": phoneNumber
        ])

        return await networkLayer.execute(RegistrationResponse.self, using: request)
    }

    func authenticateViaGoogle(token: String) async {
        // TODO: imp -
    }

    func authenticateViaFacebook(token: String) async {
        // TODO: imp -
    }

    func verifyRegistration(email: String, code: String) async -> VerificationEntity? {
        var request = URLRequest(url: EndPoint.verifyRegistration.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email,
            "confirmation_code": code
        ])

        return await networkLayer.execute(VerificationEntity.self, using: request)
    }

    func resetPassword(email: String) async -> PasswordResetEntity? {
        var request = URLRequest(url: EndPoint.resetLink.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email
        ])

        return await networkLayer.execute(PasswordResetEntity.self, using: request)
    }

    func getUserInformation(using token: String) async -> UserInformationEntity? {
        let tokenType = "Bearer"

        var request = URLRequest(url: EndPoint.userInformation.fullUrl)
        request.setMethod(.get)
        request.setContentType(.applicationJson)
        request.setValue("\(tokenType) \(token)", forHTTPHeaderField: "Authorization")

        guard let dto = await networkLayer.execute(UserInformationDTO.self, using: request) else { return nil }

        return UserInformationEntity(
            email: dto.email,
            fullName: dto.name,
            phoneNumber: dto.phoneNumber
        )
    }
}
