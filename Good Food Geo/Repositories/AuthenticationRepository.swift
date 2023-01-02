//
//  AuthenticationRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 31.12.22.
//

import Foundation

protocol AuthenticationRepository {
    func login(email: String, password: String) async -> LoginResponse?
    func register(email: String, name: String, password: String, phoneNumber: String) async -> RegistrationResponse?
    func refreshToken(_ token: String) async
    func authenticateViaGoogle(token: String) async
    func authenticateViaFacebook(token: String) async
    func verifyRegistration(email: String, code: String) async
}

struct DefaultAuthenticationRepository: AuthenticationRepository {
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
        var request = URLRequest(url: EndPoint.login.fullUrl)
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
//        guard let url = EndPoint.verifyRegistration.fullUrl else { return nil }
//
//        var request = URLRequest(url: url)
//        request.setMethod(.get)
//        request.setContentType(.applicationJson)
//        request.setBody([
//            "email": email,
//            "password": password
//        ])
//
//        return await networkLayer.execute(LoginResponse.self, using: request)
    }
}
