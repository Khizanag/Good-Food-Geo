//
//  RegistrationViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine
import FacebookLogin
import SwiftUI

@MainActor
final class RegistrationViewModel: BaseViewModel {
    // MARK: - Properties
    private let repository: MainRepository = DefaultMainRepository()
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

    private var registeredEmail = ""

    @Published var shouldLogin = false

    var eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Functions
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

        Task {
            isRegistrationLoading = true

            let result = await repository.register(with: params)

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
                isRegistrationCompleted = true
                showError(.descriptive(entity.message))
            case .failure(let error):
                showError(error)
            }

            isVerificationLoading = false
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

    func registerUsingGoogle() {
        #warning("Implement register using Google")
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
                    self.shouldLogin = true
                }
            } else {
                // Is not registered, needs registration
                eventPublisher.send(.updateFields(
                    name: entity.name ?? "",
                    email: entity.email ?? ""
                ))
                DispatchQueue.main.async {
                    self.setSocialNetworkIsLoadingButton(to: false, for: socialNetwork)
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

extension RegistrationViewModel {
    enum Event {
        case updateFields(name: String, email: String)
    }
}

// MARK: - Params
struct RegistrationParams {
    let email: String
    let password: String
    let repeatedPassword: String
    let fullName: String
    let phoneNumber: String
    let userAgreesTermsAndConditions: Bool
}
