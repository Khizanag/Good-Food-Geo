//
//  RegistrationViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine

@MainActor
final class RegistrationViewModel: DefaultViewModel {
    private let repository: Repository = DefaultRepository()
    private let verifyRegistrationUseCase: VerifyRegistrationUseCase = DefaultVerifyRegistrationUseCase()
    @Published var isVerificationCodeSent = false
    @Published var isRegistrationCompleted = false

    private var registeredEmail = ""

    // MARK: - Functions
    func register(with params: RegistrationParams) {
        guard params.userAgreesTermsAndConditions else {
            showError(.descriptive("To continue registration you should agree with our terms and conditions"))
            return
        }
        guard params.password == params.repeatedPassword else {
            showError(.descriptive("Passwords does not match!"))
            return
        }
        guard [params.fullName, params.password, params.email, params.phoneNumber].allSatisfy({ !$0.isEmpty }) else {
            showError(.descriptive("Fields should not be empty"))
            return
        }

        Task {
            let result = await repository.register(with: params)

            switch result {
            case .success(let entity):
                registeredEmail = entity.email

                isVerificationCodeSent = true
            case .failure(let error):
                showError(error)
            }
        }
    }

    func registerUsingFacebook() {

    }

    func registerUsingGoogle() {

    }

    func verifyRegistration(using code: String) {
        Task {
            let result = await verifyRegistrationUseCase.execute(email: registeredEmail, code: code)

            switch result {
            case .success(let entity):
                // showMessage entity.message
                isRegistrationCompleted = true
            case .failure(let error):
                showError(error)
            }
        }
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
