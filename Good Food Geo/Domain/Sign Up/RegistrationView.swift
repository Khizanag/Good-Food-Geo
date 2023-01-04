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
                    CompanyButton(company: Company.facebook, action: registerWithFacebook)
                    CompanyButton(company: Company.google, action: registerWithGoogle)
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

                if verificationSegmentShouldBeShown {
                    if viewModel.isVerificationCodeSent {
                        verificationSection

                        if !verificationCode.isEmpty {
                            registrationButton
                        }
                    } else {
                        getVerificationCodeButton
                    }
                }
            }
            .padding(32)
        }
        .navigationTitle(Localization.signUpTitle())
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
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

    private var verificationCodeTextField: some View {
        ZStack {
            PrimaryTextField(text: $verificationCode, placeholder: Localization.codePlaceholder())

            if viewModel.isVerificationCodeSent {
                HStack {
                    Spacer()

                    Button(action: {
                        viewModel.sendVerificationCode()
                    }, label: {
                        Text(Localization.resend())
                            .font(.caption2)
                            .padding(4)
                            .foregroundColor(.white)
                            .background(DesignSystem.Color.primary())
                            .cornerRadius(4)
                            .padding(.trailing)
                    })
                }
            }
        }
    }

    private var registrationButton: some View {
        PrimaryButton(action: {
            viewModel.register(email: email, fullName: fullName, password: password, phoneNumber: phoneNumber)
        }, label: {
            Text(Localization.signUp())
                .foregroundColor(DesignSystem.Color.buttonTitle())
        })
    }

    private var getVerificationCodeButton: some View {
        PrimaryButton(action: {
            viewModel.sendVerificationCode()
        }, label: {
            Text(Localization.getVerificationCode())
                .foregroundColor(DesignSystem.Color.buttonTitle())
        })
    }

    private var registrationInputIsValid: Bool {
        !fullName.isEmpty
        && !email.isEmpty
        && !password.isEmpty
        && confirmPassword == password
        && !phoneNumber.isEmpty
    }

    private var verificationSegmentShouldBeShown: Bool {
        registrationInputIsValid && userAgreesTerms
    }

    private var verificationSection: some View {
        VStack(alignment: .leading) {
            Text(Localization.signUpSmsCodeInfo())
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)

            verificationCodeTextField
        }
    }

    // MARK: - Functions
    private func registerWithFacebook() {

    }

    private func registerWithGoogle() {

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
