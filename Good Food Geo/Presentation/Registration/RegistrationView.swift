//
//  RegistrationView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import AuthenticationServices
import SwiftUI

struct RegistrationView: View {
    @AppStorage(AppStorageKey.appleAuthenticationName()) private var appleAuthenticationName: String?
    @AppStorage(AppStorageKey.appleAuthenticationEmail()) private var appleAuthenticationEmail: String?

    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel: RegistrationViewModel

    @Binding var fullName: String
    @Binding var email: String
    @Binding var appleUserId: String?
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var userAgreesTerms = false
    @State private var verificationCode = ""
    @State private var isTermsAndConditionsSheetPresented = false

    @FocusState private var focusedField: Field?

    @State var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                thirdPartyAuthenticationMethods

                Text(Localization.registrationSubtitle())
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Color.primaryText())

                form

                Toggle(isOn: $userAgreesTerms) {
                    Text(Localization.agreeRegistrationTermsDescription())
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
        .navigationTitle(Localization.registrationTitle())
        .onReceive(viewModel.errorPublisher, perform: showError)
        .onReceive(viewModel.eventPublisher) { event in
            switch event {
            case .dismiss:
                dismiss()
            case .updateFields(name: let fullName, email: let email):
                self.fullName = fullName
                self.email = email
                focusedField = .email.next
            }
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
        .disabled(
            viewModel.isGoogleButtonLoading ||
            viewModel.isFacebookButtonLoading ||
            viewModel.isRegistrationLoading ||
            viewModel.isVerificationLoading
        )
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
                Text(Localization.register())
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
                Text(Localization.verify())
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

    private var thirdPartyAuthenticationMethods: some View {
        VStack(spacing: 12) {
            CompanyButton(
                company: Company.facebook,
                action: { viewModel.registerUsingFacebook() },
                isLoading: $viewModel.isFacebookButtonLoading
            )

            CompanyButton(
                company: Company.google,
                action: {
                    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
                    viewModel.registerUsingGoogle(withPresenting: presentingViewController)
                },
                isLoading: $viewModel.isGoogleButtonLoading
            )

            SignInWithAppleButton(onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        if let firstName = appleIDCredential.fullName?.givenName,
                           let lastName = appleIDCredential.fullName?.familyName
                        {
                            appleAuthenticationName = firstName + " " + lastName
                        }

                        if let email = appleIDCredential.email {
                            appleAuthenticationEmail = email
                        }

                        viewModel.authenticateUsingApple(
                            userId: appleIDCredential.user,
                            email: appleAuthenticationEmail,
                            fullName: appleAuthenticationName)
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    showError(.general)
                }
            })
            .frame(height: 50)
        }
    }

    // MARK: - Functions
    private func register() {
        viewModel.register(with: RegistrationParams(
            email: email,
            appleUserId: appleUserId,
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

// MARK: - Arrangeable
private extension RegistrationView {
    enum Field: Arrangeable {
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
}

// MARK: - Previews
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(
            viewModel: RegistrationViewModel(),
            fullName: .constant("fullname"),
            email: .constant("email"),
            appleUserId: .constant(nil)
        )
    }
}
