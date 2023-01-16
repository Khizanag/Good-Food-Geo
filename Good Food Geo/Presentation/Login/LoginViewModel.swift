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
    private let authenticationRepository: AuthenticationRepository = DefaultAuthenticationRepository()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    @Published var shouldNavigateToHome = false
    @Published var shouldNavigateToRegistration = false
    @Published var isLoading: Bool
    @Published var isFacebookButtonLoading = false
    @Published var isGoogleButtonLoading = false

    var registrationName: String?
    var registrationEmail: String?

    private let loginManager = LoginManager()

    // MARK: - Init
    override init() {
        let isSessionActive = UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) != nil
        self.isLoading = isSessionActive // if session is active wait and then navigate to app

        super.init()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.shouldNavigateToHome = isSessionActive
            self.isLoading = false
        }
    }

    func login(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            showError(.descriptive(Localization.loginInputIsEmptyErrorMessage()))
            return
        }

        Task {
            DispatchQueue.main.async {
                self.isLoading = true
            }

            let result = await loginUseCase.execute(email: email, password: password)

            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.shouldNavigateToHome = true
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
        isFacebookButtonLoading = true
        loginManager.logIn(permissions: [.publicProfile, .email]) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(_, _, let token):
                guard let token = token?.tokenString else {
                    self.showError(.descriptive("Facebook login failed, caused by invalid token"))
                    self.isFacebookButtonLoading = false
                    return
                }
                Task {
                    let result = await self.authenticationRepository.authenticateUsingFacebook(with: token)

                    switch result {
                    case .success(let entity):
                        if let token = entity.token {
                            self.authenticationTokenStorage.write(token)
                            DispatchQueue.main.async {
                                self.shouldNavigateToHome = true
                            }
                        } else {
                            // Is not registered, needs registration
                            self.registrationName = entity.name
                            self.registrationEmail = entity.email
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.shouldNavigateToRegistration = true
                            }
                        }
                    case .failure(let error):
                        self.showError(error)
                    }

                    DispatchQueue.main.async {
                        self.isFacebookButtonLoading = false
                    }
                }
            case .cancelled:
                self.showError(.descriptive("Facebook login canceled"))
            case .failed(let error):
                self.showError(.descriptive("Facebook login failed"))
                print(error.localizedDescription)
            }
        }
    }

    func loginUsingGoogle() {
        showError(.descriptive("Login using Google currently is not supported"))
    }
}
