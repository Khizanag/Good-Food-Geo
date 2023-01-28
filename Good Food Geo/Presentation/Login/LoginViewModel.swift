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
    private let loginUseCase: LoginUseCase = DefaultLoginUseCase()
    private let authenticationRepository: AuthenticationRepository = DefaultAuthenticationRepository()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared
    private let facebookLoginManager = LoginManager()
    private let languageStorage: LanguageStorage = DefaultLanguageStorage.shared

    @Published var shouldNavigateToHome = false
    @Published var shouldNavigateToRegistration = false
    @Published var isLoading = false
    @Published var isFacebookButtonLoading = false
    @Published var isGoogleButtonLoading = false

    var registrationName = ""
    var registrationEmail = ""

    // MARK: - Methods
    func viewDidAppear() {
        let isSessionActive = UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) != nil
        shouldNavigateToHome = isSessionActive
        isLoading = false
    }

    func changeLanguage(to newLanguage: Language) {
        languageStorage.write(newLanguage)
    }

    @MainActor func login(email: String, password: String) {
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
        let configuration = GIDConfiguration(clientID: "469167745457-fnccgvj7ntdvcn19br65g5542sbnfpd7")
        GIDSignIn.sharedInstance.configuration = configuration
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
            if let _ = error {
                self.showError(.general)
            } else {
                guard let token = user?.serverAuthCode else {
                    self.showError(.general)
                    return
                }

                Task {
                    await self.handleSocialNetworkAuthentication(for: .facebook, using: token)
                }
            }
        }
    }

    // MARK: - Private
    @MainActor private func handleSocialNetworkAuthentication(for socialNetwork: AuthenticatingSocialNetwork, using token: String) async {
        let result = await self.authenticationRepository.authenticateUsingFacebook(with: token)

        switch result {
        case .success(let entity):
            if let token = entity.token {
                authenticationTokenStorage.write(token)
                DispatchQueue.main.async {
                    self.setSocialNetworkIsLoadingButton(to: false, for: socialNetwork)
                    self.shouldNavigateToHome = true
                }
            } else {
                // Is not registered, needs registration
                self.registrationName = entity.name ?? ""
                self.registrationEmail = entity.email ?? ""
                DispatchQueue.main.async {
                    self.setSocialNetworkIsLoadingButton(to: false, for: socialNetwork)
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

    private func setSocialNetworkIsLoadingButton(to isLoading: Bool, for socialNetwork: AuthenticatingSocialNetwork) {
        switch socialNetwork {
        case .facebook: isFacebookButtonLoading = isLoading
        case .google: isGoogleButtonLoading = isLoading
        }
    }
}
