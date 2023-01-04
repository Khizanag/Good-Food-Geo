//
//  LoginViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase = DefaultLoginUseCase()

    @Published var shouldNavigateInto: Bool = false
    @Published var isLoading: Bool

    // MARK: - Init
    init() {
        let isSessionActive = UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) != nil
        self.isLoading = isSessionActive // is session is active wait and then navigate to app

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
            self?.shouldNavigateInto = isSessionActive
        }
    }

    func login(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
//            showMessage(Localization.loginInputIsEmptyErrorMessage())
            return
        }


        Task {
            guard await loginUseCase.execute(email: email, password: password) else { return }
            shouldNavigateInto = true
        }
    }

    func loginUsingFacebook() {
        print("loginUsingFacebook")
    }

    func loginUsingGoogle() {
        print("loginUsingGoogle")
    }
}
