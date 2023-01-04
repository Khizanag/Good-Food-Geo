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
    func refreshToken(_ token: String) async
    func authenticateViaGoogle(token: String) async
    func authenticateViaFacebook(token: String) async
    func verifyRegistration(email: String, code: String) async

    func getUserInformation(email: String, password: String) async -> UserInfoEntity?
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

    func refreshToken(_ token: String) async {
        // TODO
    }

    func authenticateViaGoogle(token: String) async {
        // TODO
    }

    func authenticateViaFacebook(token: String) async {
        // TODO
    }

    func verifyRegistration(email: String, code: String) async {

    }

    func getUserInformation(email: String, password: String) async -> UserInfoEntity? {
        var request = URLRequest(url: EndPoint.userInformation.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email,
            "password": password
        ])

        return await networkLayer.execute(UserInfoEntity.self, using: request)
    }
}
