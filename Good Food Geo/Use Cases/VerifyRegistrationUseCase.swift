//
//  RegisterUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

protocol VerifyRegistrationUseCase {
    func execute(email: String, code: String) async -> Result<VerificationEntity, AppError>
}

struct DefaultVerifyRegistrationUseCase: VerifyRegistrationUseCase {
    private let repository: MainRepository = DefaultMainRepository()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared
    
    func execute(email: String, code: String) async -> Result<VerificationEntity, AppError> {
        let result = await repository.verifyRegistration(email: email, code: code)
        
        switch result {
        case .success(let entity):
            let token = entity.token.access
            authenticationTokenStorage.write(token)
            return .success(entity)
        case .failure(let error):
            return .failure(error)
        }
    }
}
