//
//  RegistrationViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import SwiftUI

@MainActor
final class RegistrationViewModel: ObservableObject {
    private let repository: Repository = DefaultRepository()
    private let verifyRegistrationUseCase: VerifyRegistrationUseCase = DefaultVerifyRegistrationUseCase()
    @Published var isVerificationCodeSent = false
    @Published var isRegistrationCompleted = false

    private var registeredEmail = ""

    // MARK: - Init
    init() {

    }

    func register(with params: RegistrationParams) {
        Task {
            guard let entity = await repository.register(with: params) else { return }

            registeredEmail = entity.email

            isVerificationCodeSent = true
        }
    }

    func registerUsingFacebook() {

    }

    func registerUsingGoogle() {

    }

    func verifyRegistration(using code: String) {
        Task {
            guard let _ = await verifyRegistrationUseCase.execute(email: registeredEmail, code: code) else { return }
            isRegistrationCompleted = true
        }
    }
}

// MARK: - Params
struct RegistrationParams {
    let email: String
    let password: String
    let fullName: String
    let phoneNumber: String
}
