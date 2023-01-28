//
//  LoginView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    private enum Field: Arrangeable {
        case email
        case password

        var arranged: [LoginView.Field] {
            [.email, .password]
        }
    }

    @ObservedObject var viewModel: LoginViewModel

    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?
    @AppStorage(AppStorageKey.language()) private var language: Language = .english

    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    @State var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HSpacing(8)

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

                VStack(alignment: .leading, spacing: 6) {
                    Text(Localization.loginTitle())
                        .font(.body)
                        .bold()

                    Text(Localization.loginSubtitle())
                        .font(.footnote)
                        .foregroundColor(DesignSystem.Color.secondaryText())
                }
                .padding()

                VStack(alignment: .leading, spacing: 8) {
                    FormItemView(model: FormItemModel(
                        icon: DesignSystem.Image.email(),
                        placeholder: Localization.email(),
                        keyboardType: .emailAddress
                    ), text: $email)
                    .focused($focusedField, equals: .email)


                    ZStack {
                        FormItemView(model: FormItemModel(
                            icon: DesignSystem.Image.lock(),
                            placeholder: Localization.password(),
                            isSecured: true
                        ), text: $password)
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

                PrimaryButton(
                    action: {
                        viewModel.login(email: email, password: password)
                    },
                    label: {
                        Text(Localization.login())
                    },
                    isLoading: $viewModel.isLoading
                )

//#if DEBUG
//                PrimaryButton(action: {
//                    viewModel.login(email: "admin@gfg.ge", password: "admin")
//                }, label: {
//                    Text("Test login by Admin")
//                }, isLoading: $viewModel.isLoading)
//#endif

                Text(Localization.loginWithSocialNetworksTitle())
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Color.primaryText())

                VStack(spacing: 12) {
                    CompanyButton(
                        company: Company.facebook,
                        action: { viewModel.loginUsingFacebook() },
                        isLoading: $viewModel.isFacebookButtonLoading
                    )

//                    CompanyButton(
//                        company: Company.google,
//                        action: {
//                            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
//
//                            viewModel.loginUsingGoogle(by: presentingViewController)
//                        },
//                        isLoading: $viewModel.isGoogleButtonLoading
//                    )
                }

                HStack {
                    Text(Localization.areYouNotRegistered())
                        .font(.footnote)

                    Button(action: {
                        viewModel.shouldNavigateToRegistration = true
                    }, label: {
                        Text(Localization.register())
                    })
                }
                .padding(.vertical)
            }
            .padding([.horizontal, .bottom], 32)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.shouldNavigateToHome) {
                MainTabBarView()
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToRegistration) {
                RegistrationView(
                    viewModel: RegistrationViewModel(),
                    fullName: $viewModel.registrationName,
                    email: $viewModel.registrationEmail

                )
            }
            .onAppear {
                cleanUp()
                viewModel.viewDidAppear()
            }
            .allowsHitTesting(!viewModel.isLoading)
            .onReceive(viewModel.errorPublisher, perform: showError)
            .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
                Button(Localization.gotIt(), role: .cancel) { }
            })
        }
        .scrollDismissesKeyboard(.interactively)
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

// MARK: - Previews
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
