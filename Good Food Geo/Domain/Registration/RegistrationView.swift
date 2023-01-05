//
//  RegistrationView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var userAgreesTerms = false

    @State private var verificationCode = ""

    @State var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    CompanyButton(company: Company.facebook, action: viewModel.registerUsingFacebook)
                    CompanyButton(company: Company.google, action: viewModel.registerUsingGoogle)
                }

                Text(Localization.signUpSubtitle())
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Color.primaryText())

                form

                Toggle(isOn: $userAgreesTerms) {
                    Text(Localization.agreeNotifications())
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(DesignSystem.Color.secondaryText())
                        .multilineTextAlignment(.trailing)
                }

                if viewModel.isVerificationCodeSent {
                    verificationSection
                } else {
                    registerAndGetVerificationCodeButton
                }
            }
            .padding(32)
        }
        .navigationTitle(Localization.signUpTitle())
        .onReceive(viewModel.eventPublisher) { event in
            switch event {
            case .showMessage(let message):
                showMessage(message)
            }
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
        .navigationDestination(isPresented: $viewModel.isRegistrationCompleted, destination: {
            MainTabBarView()
        })
    }

    // MARK: - Components
    private var form: some View {
        VStack(spacing: 8) {
            FormItemView(model: FormItemModel(
                icon: DesignSystem.Image.person(),
                placeholder: Localization.fullName()
            ), text: $fullName)

            FormItemView(model: FormItemModel(
                icon: DesignSystem.Image.email(),
                placeholder: Localization.email(),
                keyboardType: .emailAddress
            ), text: $email)

            FormItemView(model: FormItemModel(
                icon: DesignSystem.Image.lock(),
                placeholder: Localization.password(),
                isSecured: true
            ), text: $password)

            FormItemView(model: FormItemModel(
                icon: DesignSystem.Image.lockOpened(),
                placeholder: Localization.confirmPassword(),
                isSecured: true
            ), text: $confirmPassword)

            FormItemView(model: FormItemModel(
                icon: DesignSystem.Image.phone(),
                placeholder: Localization.phoneNumber(),
                keyboardType: .phonePad
            ), text: $phoneNumber)
        }
    }

    private var registerAndGetVerificationCodeButton: some View {
        PrimaryButton(action: {
            viewModel.register(with: RegistrationParams(
                email: email,
                password: password,
                repeatedPassword: confirmPassword,
                fullName: fullName,
                phoneNumber: phoneNumber,
                userAgreesTermsAndConditions: userAgreesTerms
            ))
        }, label: {
            Text("Register and Get Verification Code")
        })
    }

    private var verifyRegistrationButton: some View {
        PrimaryButton(action: {
            viewModel.verifyRegistration(using: verificationCode)
        }, label: {
            Text("Verify Registration")
        })
    }

    private var verificationSection: some View {
        VStack(alignment: .leading) {
            Text(Localization.signUpSmsCodeInfo())
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)

            verificationCodeTextField

            if !verificationCode.isEmpty {
                verifyRegistrationButton
            }
        }
    }

    private var verificationCodeTextField: some View {
        PrimaryTextField(text: $verificationCode, placeholder: Localization.codePlaceholder())
            .textContentType(.oneTimeCode)
    }

    // MARK: - Message Displayer
    private func showMessage(_ message: String, description: String? = nil) {
        alertData.title = message
        if let description {
            alertData.subtitle = description
        }
        alertData.isPresented = true
    }
}

// MARK: - Previews
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel())
    }
}
