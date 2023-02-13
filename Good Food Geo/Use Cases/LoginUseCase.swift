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
    private let repository: MainRepository = DefaultMainRepository()

    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?
    
    func execute(email: String, password: String) async -> Result<Void, AppError> {
        switch await repository.login(email: email, password: password) {
        case .success(let entity):
            authenticationToken = entity.token.access
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
