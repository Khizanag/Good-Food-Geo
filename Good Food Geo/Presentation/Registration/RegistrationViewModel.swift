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
            showError(.descriptive("რეგისტრაციის პროცესის გაგრძელებისათვის, აუცილებელია, რომ დაეთანხმოთ წესებსა და პირობებს"))
            return
        }
        guard params.password == params.repeatedPassword else {
            showError(.descriptive("პაროლები არ ემთხვევა ერთმანეთს"))
            return
        }
        guard [params.fullName, params.password, params.email, params.phoneNumber].allSatisfy({ !$0.isEmpty }) else {
            showError(.descriptive("გთხოვთ, შეავსოთ ყველა ველი"))
            return
        }

        Task {
            let result = await repository.register(with: params)

            switch result {
            case .success(let entity):
                registeredEmail = entity.email
                isVerificationCodeSent = true
                showError(.descriptive(entity.message))
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
                isRegistrationCompleted = true
                showError(.descriptive(entity.message))
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
