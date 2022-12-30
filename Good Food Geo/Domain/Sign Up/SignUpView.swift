//
//  SignUpView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var emailId = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var userAgreesTerms = false

    @State private var verificationCode = ""

    @State private var isVerificationCodeSent = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    CompanyButton(company: Company.facebook, action: signUpWithFacebook)
                    CompanyButton(company: Company.google, action: signUpWithGoogle)
                }

                Text("Or, register with Email") // TODO: Loc
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
                .tint(DesignSystem.Color.primary())
                .padding()

                if verificationSegmentShouldBeShown {
                    if isVerificationCodeSent {
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
        .navigationTitle("Sign Up With..")
    }

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
            ), text: $emailId)

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

            if isVerificationCodeSent {
                HStack {
                    Spacer()

                    Button(action: {
                        sendVerificationCode()
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
            signUp()
        }, label: {
            Text(Localization.signUp())
                .foregroundColor(DesignSystem.Color.buttonTitle())
        })
    }

    private var getVerificationCodeButton: some View {
        PrimaryButton(action: {
            sendVerificationCode()
        }, label: {
            Text(Localization.getVerificationCode())
                .foregroundColor(DesignSystem.Color.buttonTitle())
        })
    }

    private var registrationInputIsValid: Bool {
        !fullName.isEmpty
        && !emailId.isEmpty
        && !password.isEmpty
        && confirmPassword == password
        && !phoneNumber.isEmpty
    }

    private var verificationSegmentShouldBeShown: Bool {
        registrationInputIsValid && userAgreesTerms
    }

    private var verificationSection: some View {
        VStack(alignment: .leading) {
            Text("The activation code will be sent via SMS")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)

            verificationCodeTextField
        }
    }

    // MARK: - Functions
    private func sendVerificationCode() {
        isVerificationCodeSent = true
    }

    private func signUp() {

    }

    private func signUpWithFacebook() {

    }

    private func signUpWithGoogle() {

    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
