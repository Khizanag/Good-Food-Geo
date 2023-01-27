//
//  RegistrationViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine

@MainActor
final class RegistrationViewModel: DefaultViewModel {
    private let repository: MainRepository = DefaultMainRepository()
    private let verifyRegistrationUseCase: VerifyRegistrationUseCase = DefaultVerifyRegistrationUseCase()

    @Published var isRegistrationCompleted = false
    @Published var isVerificationCodeSent = false

    @Published var isRegistrationLoading = false
    @Published var isVerificationLoading = false

    private var registeredEmail = ""

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

    func registerUsingFacebook() {
        // TODO: stub
    }

    func registerUsingGoogle() {
        // TODO: stub
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

    func loginUsingFacebook() {
        #warning("Fix and finish that flow")
//        isFacebookButtonLoading = true
//        facebookLoginManager.logIn(permissions: [.publicProfile, .email]) { [weak self] result in
//            guard let self else { return }
//
//            switch result {
//            case .success(_, _, let token):
//                guard let token = token?.tokenString else {
//                    self.showError(.descriptive("Facebook-ით ავტორიზაცია წარუმატებელია"))
//                    self.isFacebookButtonLoading = false
//                    return
//                }
//
//                Task {
//                    await self.handleFacebookAuthentication(using: token)
//                }
//            case .cancelled:
//                self.isFacebookButtonLoading = false
//                self.showError(.descriptive("Facebook-ით ავტორიზაცია შეწყდა"))
//            case .failed(let error):
//                self.isFacebookButtonLoading = false
//                self.showError(.descriptive("Facebook-ით ავტორიზაცია წარუმატებელია"))
//                debugPrint(error.localizedDescription)
//            }
//        }
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
