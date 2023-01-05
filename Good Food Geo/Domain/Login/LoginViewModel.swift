//
//  LoginViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import SwiftUI
import FacebookLogin

@MainActor
final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase = DefaultLoginUseCase()

    @Published var shouldNavigateInto: Bool = false
    @Published var isLoading: Bool

    private let loginManager = LoginManager()

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
//            print("Facebook login did tap")
//        loginManager.logIn(permissions: [.publicProfile, .email]) { result in }
            //                print("Login using fb did finish")
            //                switch result {
            //                case .success(let grantedPermissions, let declinedPermissions, let token):
            //                    print("FB Login success: token", token?.tokenString ?? "nil")
            //                case .cancelled: print("Facebook login canceled")
            //                case .failed(let error):
            //                    print(error.localizedDescription)
            //                }
            //            }
    }

    func loginUsingGoogle() {
        print("loginUsingGoogle")
    }
}
