//
//  LoginViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import SwiftUI
import FacebookLogin
import GoogleSignIn

final class LoginViewModel: BaseViewModel {
    // MARK: - Properties
    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?

    private let loginUseCase: LoginUseCase = DefaultLoginUseCase()
    private let authenticationRepository: AuthenticationRepository = DefaultAuthenticationRepository()
    private let facebookLoginManager = LoginManager()
    private let languageStorage: LanguageStorage = DefaultLanguageStorage.shared

    @Published var shouldNavigateToHome = false
    @Published var shouldNavigateToRegistration = false
    @Published var isLoading = false
    @Published var isAppleButtonLoading = false
    @Published var isFacebookButtonLoading = false
    @Published var isGoogleButtonLoading = false

    var registrationName = ""
    var registrationEmail = ""
    var appleUserId: String?

    // MARK: - Public
    func changeLanguage(to newLanguage: Language) {
        languageStorage.write(newLanguage)
    }

    @MainActor func login(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            showError(.descriptive(Localization.loginInputIsEmptyErrorMessage()))
            return
        }

        Task {
            isLoading = true

            let result = await loginUseCase.execute(email: email.lowercased(), password: password)

            switch result {
            case .success:
                self.shouldNavigateToHome = true
            case .failure(let error):
                showError(error)
            }

            isLoading = false
        }
    }

    @MainActor func loginUsingApple(userId: String, fullName: String?, email: String?) {
        isAppleButtonLoading = true
        Task {
            let result = await authenticationRepository.authenticateUsingApple(with: userId)

            switch result {
            case .success(let entity):
                authenticationToken = entity.login.access
                shouldNavigateToHome = true
            case .failure:
                appleUserId = userId
                registrationName = fullName ?? ""
                registrationEmail = email ?? ""
                shouldNavigateToRegistration = true
            }

            isAppleButtonLoading = false
        }
    }

    @MainActor func loginUsingFacebook() {
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
                    await self.handleSocialNetworkAuthentication(for: .facebook, using: token)
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

    @MainActor func loginUsingGoogle(by presentingViewController: UIViewController) {
        isGoogleButtonLoading = true
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            guard let result, let token = result.user.idToken?.tokenString else {
                self.showError(.general)
                self.isGoogleButtonLoading = false
                return
            }

            Task {
                await self.handleSocialNetworkAuthentication(for: .google, using: token)
            }
        }
    }

    // MARK: - Private
    @MainActor private func handleSocialNetworkAuthentication(for socialNetwork: AuthenticatingSocialNetwork, using token: String) async {
        let result = await {
            switch socialNetwork {
            case .facebook: return await self.authenticationRepository.authenticateUsingFacebook(with: token)
            case .google: return await self.authenticationRepository.authenticateUsingGoogle(with: token)
            }
        }()

        switch result {
        case .success(let entity):
            if let token = entity.token {
                authenticationToken = token
                setSocialNetworkIsLoadingButton(to: false, for: socialNetwork)
                shouldNavigateToHome = true
            } else {
                // Is not registered, needs registration
                registrationName = entity.name ?? ""
                registrationEmail = entity.email ?? ""
                setSocialNetworkIsLoadingButton(to: false, for: socialNetwork)
                shouldNavigateToRegistration = true
            }
        case .failure(let error):
            isFacebookButtonLoading = false
            showError(error)
        }
    }

    private func setSocialNetworkIsLoadingButton(to isLoading: Bool, for socialNetwork: AuthenticatingSocialNetwork) {
        switch socialNetwork {
        case .facebook: isFacebookButtonLoading = isLoading
        case .google: isGoogleButtonLoading = isLoading
        }
    }
}
