//
//  RegistrationViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine

@MainActor
final class RegistrationViewModel: ObservableObject {
    private let repository: Repository = DefaultRepository()
    private let verifyRegistrationUseCase: VerifyRegistrationUseCase = DefaultVerifyRegistrationUseCase()
    @Published var isVerificationCodeSent = false
    @Published var isRegistrationCompleted = false

    private var registeredEmail = ""

    enum Event {
        case showMessage(String)
    }

    var eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Functions
    func register(with params: RegistrationParams) {
        guard params.userAgreesTermsAndConditions else {
            eventPublisher.send(.showMessage("To continue registration you should agree with our terms and conditions"))
            return
        }
        guard params.password == params.repeatedPassword else {
            eventPublisher.send(.showMessage("Passwords does not match!"))
            return
        }

        Task {
            guard let entity = await repository.register(with: params) else {
                eventPublisher.send(.showMessage("Error during Registration. Enter correct information!"))
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
            guard let _ = await verifyRegistrationUseCase.execute(email: registeredEmail, code: code) else {
                eventPublisher.send(.showMessage("Error during Verification"))
                return
            }
            isRegistrationCompleted = true
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
