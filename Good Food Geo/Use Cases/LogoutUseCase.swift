//
//  LogoutUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

protocol LogoutUseCase {
    func execute()
}

struct DefaultLogoutUseCase: LogoutUseCase {
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    func execute() {
        authenticationTokenStorage.delete()
    }
}
