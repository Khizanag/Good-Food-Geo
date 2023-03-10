//
//  LoginView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    // MARK: - Properties
    @AppStorage(AppStorageKey.language()) private var language: Language = .default
    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?
    @AppStorage(AppStorageKey.appleAuthenticationName()) private var appleAuthenticationName: String?
    @AppStorage(AppStorageKey.appleAuthenticationEmail()) private var appleAuthenticationEmail: String?

    @StateObject var viewModel: LoginViewModel

    @State private var shouldLogIn = false

    @State private var email = ""
    @State private var password = ""

    @FocusState private var focusedField: Field?

    @State var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HSpacing(8)

                header

                subHeader

                inputFieldsForm

                PrimaryButton(
                    action: { viewModel.login(email: email, password: password) },
                    label: { Text(Localization.login()) },
                    isLoading: $viewModel.isLoading
                )
                .onAppear {
                    cleanUp()
                    if authenticationToken != nil {
                        shouldLogIn = true
                    }
                }
                .navigationDestination(isPresented: $shouldLogIn, destination: {
                    MainTabBarView(viewModel: MainTabBarViewModel())
                })

#if DEBUG
                PrimaryButton(
                    action: { viewModel.login(email: "admin@gfg.ge", password: "admin") },
                    label: { Text("Test login by Admin") },
                    isLoading: $viewModel.isLoading
                )
#endif

                Text(Localization.loginWithSocialNetworksTitle())
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Color.primaryText())

                thirdPartyAuthenticationMethods

                registerSuggestion
            }
            .padding([.horizontal, .bottom], 32)
        }
        .allowsHitTesting(!viewModel.isLoading)
        .onReceive(viewModel.errorPublisher, perform: showError)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.shouldNavigateToHome) {
            MainTabBarView(viewModel: MainTabBarViewModel())
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateToRegistration) {
            RegistrationView(
                viewModel: RegistrationViewModel(),
                fullName: $viewModel.registrationName,
                email: $viewModel.registrationEmail,
                appleUserId: $viewModel.appleUserId
            )
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
        .scrollDismissesKeyboard(.interactively)
        .disabled(viewModel.isLoading || viewModel.isGoogleButtonLoading || viewModel.isFacebookButtonLoading)
    }

    // MARK: - Components
    private var header: some View {
        HStack {
            DesignSystem.Image.appIconPrimary()
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 48)

            Spacer()

            Menu(Localization.changeLanguage()) {
                ForEach(Language.allCases, id: \.localizableIdentifier) { language in
                    Button(action: {
                        viewModel.changeLanguage(to: language)
                    }, label: {
                        let title = "\(language.icon) \(language.name)"

                        if language == self.language {
                            Label(title, systemImage: "checkmark")
                        } else {
                            Text(title)
                        }
                    })
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.bottom, .horizontal])
    }

    private var subHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Localization.loginTitle())
                .font(.body)
                .bold()

            Text(Localization.loginSubtitle())
                .font(.footnote)
                .foregroundColor(DesignSystem.Color.secondaryText())
        }
        .padding()
    }

    private var inputFieldsForm: some View {
        Group {
            FormItemView(
                model: FormItemModel(
                    icon: DesignSystem.Image.email(),
                    placeholder: Localization.email(),
                    keyboardType: .emailAddress
                ),
                text: $email
            )
            .focused($focusedField, equals: .email)

            ZStack {
                FormItemView(
                    model: FormItemModel(
                        icon: DesignSystem.Image.lock(),
                        placeholder: Localization.password(),
                        isSecured: true
                    ),
                    text: $password
                )
                .focused($focusedField, equals: .password)

                HStack {
                    Spacer()

                    NavigationLink(destination: {
                        PasswordResetView(viewModel: PasswordResetViewModel())
                    }, label: {
                        Text(Localization.forgotButtonTitle())
                            .foregroundColor(DesignSystem.Color.primary())
                            .font(.footnote)
                            .padding(.trailing)
                    })
                }
            }
        }
        .onSubmit {
            guard let focusedField = focusedField else { return }
            guard let nextField = focusedField.next else {
                viewModel.login(email: email, password: password)
                return
            }
            self.focusedField = nextField
        }
    }

    private var thirdPartyAuthenticationMethods: some View {
        VStack(spacing: 12) {
            CompanyButton(
                company: Company.facebook,
                action: { viewModel.loginUsingFacebook() },
                isLoading: $viewModel.isFacebookButtonLoading
            )

            CompanyButton(
                company: Company.google,
                action: {
                    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
                    viewModel.loginUsingGoogle(by: presentingViewController)
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

                        viewModel.loginUsingApple(
                            userId: appleIDCredential.user,
                            fullName: appleAuthenticationName,
                            email: appleAuthenticationEmail)
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    showError(.general)
                }
            })
            .frame(height: 50)
        }
    }

    private var registerSuggestion: some View {
        HStack {
            Text(Localization.areYouNotRegistered())
                .font(.footnote)

            NavigationLink(destination: {
                RegistrationView(
                    viewModel: RegistrationViewModel(),
                    fullName: $viewModel.registrationName,
                    email: $viewModel.registrationEmail,
                    appleUserId: $viewModel.appleUserId
                )
            }, label: {
                Text(Localization.register())
            })
        }
        .padding(.vertical)
    }

    // MARK: - Functions
    private func cleanUp() {
        email = ""
        password = ""
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

// MARK: - Field
private extension LoginView {
    enum Field: Arrangeable {
        case email
        case password

        var arranged: [LoginView.Field] {
            [.email, .password]
        }
    }
}

// MARK: - Previews
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
