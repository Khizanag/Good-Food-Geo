//
//  RegistrationView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct RegistrationView: View {
    private enum Field: Arrangeable {
        case fullName
        case email
        case password
        case confirmationPassword
        case phoneNumber
        case verificationCode

        var arranged: [Field] {
            [.fullName, .email, .password, .confirmationPassword, .phoneNumber, .verificationCode]
        }
    }

    @ObservedObject var viewModel: RegistrationViewModel

    @State private var fullName: String
    @State private var email: String
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var userAgreesTerms = false

    @State private var verificationCode = ""

    @FocusState private var focusedField: Field?

    @State private var isTermsAndConditionsSheetPresented = false

    @State var alertData = AlertData()

    // MARK: - Init
    init(viewModel: RegistrationViewModel, email: String = "", fullName: String = "") {
        self.viewModel = viewModel
        self.email = email
        self.fullName = fullName
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    CompanyButton(company: Company.facebook, action: {
                        viewModel.registerUsingFacebook()
                    })
                    CompanyButton(company: Company.google, action: {
                        viewModel.registerUsingGoogle()
                    })
                }

                Text(Localization.signUpSubtitle())
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Color.primaryText())

                form

                Toggle(isOn: $userAgreesTerms) {
                    Text(#"დიახ, ვეთანხმები გამოყენების "წესებსა და პირობებს""#)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.trailing)
                        .onTapGesture {
                            isTermsAndConditionsSheetPresented = true
                        }
                }
                .sheet(isPresented: $isTermsAndConditionsSheetPresented) {
                    RegistrationTermsAndConditionsView(userAgreesTerms: $userAgreesTerms, isPresented: $isTermsAndConditionsSheetPresented)
                }

                if viewModel.isVerificationCodeSent {
                    verificationSection
                } else {
                    registrationButton
                }
            }
            .padding(32)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(Localization.signUpTitle())
        .onReceive(viewModel.errorPublisher, perform: showError)
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
            FormItemView(
                model: FormItemModel(
                    icon: DesignSystem.Image.person(),
                    placeholder: Localization.fullName()
                ),
                text: $fullName
            )
            .focused($focusedField, equals: .fullName)

            FormItemView(
                model: FormItemModel(
                    icon: DesignSystem.Image.email(),
                    placeholder: Localization.email(),
                    keyboardType: .emailAddress
                ),
                text: $email
            )
            .focused($focusedField, equals: .email)

            FormItemView(
                model: FormItemModel(
                    icon: DesignSystem.Image.lock(),
                    placeholder: Localization.password(),
                    isSecured: true
                ),
                text: $password
            )
            .focused($focusedField, equals: .password)

            FormItemView(
                model: FormItemModel(
                    icon: DesignSystem.Image.lockOpened(),
                    placeholder: Localization.confirmPassword(),
                    isSecured: true
                ),
                text: $confirmPassword
            )
            .focused($focusedField, equals: .confirmationPassword)

            FormItemView(
                model: FormItemModel(
                    icon: DesignSystem.Image.phone(),
                    placeholder: Localization.phoneNumber(),
                    keyboardType: .phonePad
                ),
                text: $phoneNumber
            )
            .focused($focusedField, equals: .phoneNumber)
        }
        .onSubmit {
            guard let focusedField = focusedField else { return }
            guard let nextField = focusedField.next else {
                register()
                return
            }
            self.focusedField = nextField
        }
    }

    private var registrationButton: some View {
        PrimaryButton(
            action: register,
            label: {
                Text("რეგისტრაცია")
            },
            isLoading: $viewModel.isRegistrationLoading
        )
    }

    private var verificationButton: some View {
        PrimaryButton(
            action: {
                viewModel.verifyRegistration(using: verificationCode)
            },
            label: {
                Text("ვერიფიკაცია")
            },
            isLoading: $viewModel.isVerificationLoading
        )
    }

    private var verificationSection: some View {
        VStack(alignment: .leading) {
            Text(Localization.signUpSmsCodeInfo())
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)

            verificationCodeTextField

            if !verificationCode.isEmpty {
                verificationButton
            }
        }
    }

    private var verificationCodeTextField: some View {
        PrimaryTextField(text: $verificationCode, placeholder: Localization.codePlaceholder())
            .textContentType(.oneTimeCode)
    }

    // MARK: - Functions
    private func register() {
        viewModel.register(with: RegistrationParams(
            email: email,
            password: password,
            repeatedPassword: confirmPassword,
            fullName: fullName,
            phoneNumber: phoneNumber,
            userAgreesTermsAndConditions: userAgreesTerms
        ))
    }

    // MARK: - Message Displayer
    private func showError(_ error: AppError) {
        showMessage(error.description)
    }

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
