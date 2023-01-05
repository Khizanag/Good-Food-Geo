//
//  LoginUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import SwiftUI

protocol LoginUseCase {
    func execute(email: String, password: String) async -> Bool
}

struct DefaultLoginUseCase: LoginUseCase {
    private let repository: Repository = DefaultRepository()
    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    func execute(email: String, password: String) async -> Bool {
        guard let entity = await repository.login(email: email, password: password) else { return false }

        let token = entity.token.access

        authenticationTokenStorage.write(token)

        guard let userInformationEntity = await repository.getUserInformation(using: token) else { return false }

        userInformationStorage.write(userInformationEntity)

        return true
    }
}
