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
//    @AppStorage(AppStorageKey.authenticationToken()) var authenticationToken: String?

    private let repository: Repository = DefaultRepository()

    func execute(email: String, password: String) async -> Bool {
        guard let entity = await repository.login(email: email, password: password) else { return false }

//        authenticationToken = entity.token.access
        UserDefaults.standard.setValue(entity.token.access, forKey: AppStorageKey.authenticationToken())

        print("authenticationToken updated to \(UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) ?? "")")

        return true
    }
}
