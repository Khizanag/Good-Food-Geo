//
//  RegisterUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation
import SwiftUI

protocol VerifyRegistrationUseCase {
    func execute(email: String, code: String) async -> Result<VerificationEntity, AppError>
}

struct DefaultVerifyRegistrationUseCase: VerifyRegistrationUseCase {
    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?

    private let repository: MainRepository = DefaultMainRepository()
    
    func execute(email: String, code: String) async -> Result<VerificationEntity, AppError> {
        let result = await repository.verifyRegistration(email: email, code: code)
        
        switch result {
        case .success(let entity):
            authenticationToken = entity.token.access
            return .success(entity)
        case .failure(let error):
            return .failure(error)
        }
    }
}
