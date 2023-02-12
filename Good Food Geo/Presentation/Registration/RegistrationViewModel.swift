//
//  RegistrationViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine
import FacebookLogin
import SwiftUI
import GoogleSignIn

@MainActor
final class RegistrationViewModel: BaseViewModel {
    // MARK: - Properties
    private let mainRepository: MainRepository = DefaultMainRepository()
    private let verifyRegistrationUseCase: VerifyRegistrationUseCase = DefaultVerifyRegistrationUseCase()
    private let authenticationRepository: AuthenticationRepository = DefaultAuthenticationRepository()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared
    private let facebookLoginManager = LoginManager()

    @Published var isRegistrationCompleted = false
    @Published var isVerificationCodeSent = false
    @Published var isRegistrationLoading = false
    @Published var isVerificationLoading = false
    @Published var isFacebookButtonLoading = false
    @Published var isGoogleButtonLoading = false
    @Published var isAppleButtonLoading = false

    private var registeredEmail = ""

    @Published var shouldLogin = false

    var eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Public
    func register(with params: RegistrationParams) {
        guard params.userAgreesTermsAndConditions else {
            showError(.termsAreNotAgreed)
            return
        }
        guard params.password == params.repeatedPassword else {
            showError(.passwordsMismatch)
            return
        }
        guard [params.fullName, params.password, params.email, params.phoneNumber].allSatisfy({ !$0.isEmpty }) else {
            showError(.emptyField)
            return
        }

        if params.appleUserId == nil {
            registerDefault(with: params)
        } else {
            registerWithApple(with: params)
        }
    }

    @MainActor func registerDefault(with params: RegistrationParams) {
        Task {
            isRegistrationLoading = true

            let result = await mainRepository.register(with: params)

            switch result {
            case .success(let entity):
                registeredEmail = entity.email
                isVerificationCodeSent = true
                showError(.descriptive(entity.message))
            case .failure(let error):
                showError(error)
            }

            isRegistrationLoading = false
        }
    }

    @MainActor func registerWithApple(with params: RegistrationParams) {
        Task {
            isRegistrationLoading = true

            let result = await mainRepository.registerWithApple(with: params)

            switch result {
            case .success(let entity):
                registeredEmail = entity.email
                isVerificationCodeSent = true
                showError(.descriptive(entity.message))
            case .failure(let error):
                showError(error)
            }

            isRegistrationLoading = false
        }
    }

    func verifyRegistration(using code: String) {
        Task {
            isVerificationLoading = true

            let result = await verifyRegistrationUseCase.execute(email: registeredEmail, code: code)

            switch result {
            case .success(let entity):
                eventPublisher.send(.dismiss)
                showError(.descriptive(entity.message))
            case .failure(let error):
                showError(error)
            }

            isVerificationLoading = false
        }
    }

    @MainActor func authenticateUsingApple(userId: String, email: String?, fullName: String?) {
        isAppleButtonLoading = true

        Task {
            let result = await authenticationRepository.authenticateUsingApple(with: userId)

            Task { @MainActor in
                switch result {
                case .success(let entity):
                    authenticationTokenStorage.write(entity.login.access)
                    shouldLogin = true
                case .failure:
                    eventPublisher.send(.updateFields(name: fullName ?? "", email: email ?? ""))
                }

                isAppleButtonLoading = false
            }
        }
    }

    func registerUsingFacebook() {
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

    func registerUsingGoogle(withPresenting presentingViewController: UIViewController) {
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
                authenticationTokenStorage.write(token)
                shouldLogin = true
            } else {
                // Is not registered, needs registration
                eventPublisher.send(.updateFields(
                    name: entity.name ?? "",
                    email: entity.email ?? ""
                ))
            }
        case .failure(let error):
            showError(error)
        }

        setSocialNetworkIsLoadingButton(to: false, for: socialNetwork)
    }

    private func setSocialNetworkIsLoadingButton(to isLoading: Bool, for socialNetwork: AuthenticatingSocialNetwork) {
        switch socialNetwork {
        case .facebook: isFacebookButtonLoading = isLoading
        case .google: isGoogleButtonLoading = isLoading
        }
    }
}

extension RegistrationViewModel {
    enum Event {
        case dismiss
        case updateFields(name: String, email: String)
    }
}

// MARK: - Params
struct RegistrationParams {
    let email: String
    let appleUserId: String?
    let password: String
    let repeatedPassword: String
    let fullName: String
    let phoneNumber: String
    let userAgreesTermsAndConditions: Bool
}
