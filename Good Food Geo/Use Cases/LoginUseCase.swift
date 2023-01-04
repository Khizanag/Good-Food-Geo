//
//  LoginUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import Foundation

protocol LoginUseCase {
    func execute(email: String, password: String) async -> Bool
}

struct DefaultLoginUseCase: LoginUseCase {
    private let repository: Repository = DefaultRepository()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    func execute(email: String, password: String) async -> Bool {
        guard let entity = await repository.login(email: email, password: password) else { return false }

        authenticationTokenStorage.write(entity.token)

        return true
    }
}
