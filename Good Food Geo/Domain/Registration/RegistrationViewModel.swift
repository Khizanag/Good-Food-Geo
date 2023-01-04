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

    @Published var isVerificationCodeSent = false

    private var registeredEmail = ""

    // MARK: - Init
    init() {

    }

    func register(email: String, fullName: String, password: String, phoneNumber: String) {
        Task {
            guard let entity = await repository.register(
                email: email,
                name: fullName,
                password: password,
                phoneNumber: phoneNumber
            ) else {
                return
            }

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
            await repository.verifyRegistration(email: registeredEmail, code: code)
            // TODO: save token here
            // TODO: navigate to the app
        }
    }
}

