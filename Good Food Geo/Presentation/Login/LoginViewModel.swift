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
    private let facebookLoginManager = LoginManager()

    @Published var shouldNavigateToHome = false
    @Published var shouldNavigateToRegistration = false
    @Published var isLoading = false
    @Published var isFacebookButtonLoading = false
    @Published var isGoogleButtonLoading = false

    var registrationName: String?
    var registrationEmail: String?

    func viewDidAppear() {
        let isSessionActive = UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) != nil
        self.isLoading = isSessionActive // if session is active wait and then navigate to app

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
        facebookLoginManager.logIn(permissions: [.publicProfile, .email]) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(_, _, let token):
                guard let token = token?.tokenString else {
                    self.showError(.descriptive("Facebook login is failed"))
                    self.isFacebookButtonLoading = false
                    return
                }

                Task {
                    await self.handleFacebookAuthentication(using: token)
                }
            case .cancelled:
                self.isFacebookButtonLoading = false
                self.showError(.descriptive("Facebook login has been canceled"))
            case .failed(let error):
                self.isFacebookButtonLoading = false
                self.showError(.descriptive("Facebook login is failed"))
                debugPrint(error.localizedDescription)
            }
        }
    }

    func loginUsingGoogle() {
        #warning("implement Google login and remove that message")
        showError(.descriptive("სამწუხაროდ, ამ მომენტისათვის Google-ის საშუალებით ავტორიზაცია არაა ხელმისაწვდომი"))
    }

    private func handleFacebookAuthentication(using token: String) async {
        let result = await self.authenticationRepository.authenticateUsingFacebook(with: token)

        switch result {
        case .success(let entity):
            if let token = entity.token {
                authenticationTokenStorage.write(token)
                DispatchQueue.main.async {
                    self.isFacebookButtonLoading = false
                    self.shouldNavigateToHome = true
                }
            } else {
                // Is not registered, needs registration
                self.registrationName = entity.name
                self.registrationEmail = entity.email
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isFacebookButtonLoading = false
                    self.shouldNavigateToRegistration = true
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.isFacebookButtonLoading = false
            }
            showError(error)
        }
    }
}
