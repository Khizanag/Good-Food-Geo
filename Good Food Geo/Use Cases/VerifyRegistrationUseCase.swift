//
//  RegisterUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

protocol VerifyRegistrationUseCase {
    func execute(email: String, code: String) async -> VerificationEntity?
}

struct DefaultVerifyRegistrationUseCase: VerifyRegistrationUseCase {
    private let repository: Repository = DefaultRepository()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    func execute(email: String, code: String) async -> VerificationEntity? {
        guard let response = await repository.verifyRegistration(email: email, code: code) else { return nil }
        let token = response.token.access
        authenticationTokenStorage.write(token)
        return response
    }
}
