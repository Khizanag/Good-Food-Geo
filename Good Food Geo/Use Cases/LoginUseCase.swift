//
//  LoginUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import SwiftUI

protocol LoginUseCase {
    func execute(email: String, password: String) async -> Result<Void, AppError>
}

struct DefaultLoginUseCase: LoginUseCase {
    private let repository: Repository = DefaultRepository()
    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    func execute(email: String, password: String) async -> Result<Void, AppError> {
        switch await repository.login(email: email, password: password) {
        case .success(let entity):
            let token = entity.token.access
            authenticationTokenStorage.write(token)

            let result = await repository.getUserInformation()

            switch result {
            case .success(let userInformationEntity):
                userInformationStorage.write(userInformationEntity)
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
