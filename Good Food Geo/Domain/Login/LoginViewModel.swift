//
//  LoginViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import SwiftUI
import FacebookLogin

final class LoginViewModel: DefaultViewModel {
    private let loginUseCase: LoginUseCase = DefaultLoginUseCase()

    @Published var shouldNavigateInto: Bool = false
    @Published var isLoading: Bool

    private let loginManager = LoginManager()

    // MARK: - Init
    override init() {
        let isSessionActive = UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) != nil
        self.isLoading = isSessionActive // if session is active wait and then navigate to app

        super.init()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
            self?.shouldNavigateInto = isSessionActive
            self?.isLoading = false
        }
    }

    func login(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            showError(.descriptive(Localization.loginInputIsEmptyErrorMessage()))
            return
        }


        Task {
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = true
            }


            let result = await loginUseCase.execute(email: email, password: password)

            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.shouldNavigateInto = true
                }
            case .failure(let error):
                showError(error)
            }

            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }

        }
    }

    func loginUsingFacebook() {
        showError(.descriptive("Login using Facebook currently is not supported"))
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
        showError(.descriptive("Login using Google currently is not supported"))
    }
}
