//
//  LoginView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?

    @State private var email = ""
    @State private var password = ""

    @State var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            HeaderView(viewModel: HeaderViewModel())

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

                ZStack {
                    FormItemView(model: FormItemModel(
                        icon: DesignSystem.Image.lock(),
                        placeholder: Localization.password(),
                        isSecured: true
                    ), text: $password)

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

            PrimaryButton(action: {
                viewModel.login(email: email, password: password)
            }, label: {
                Text(Localization.login())
            }, isLoading: $viewModel.isLoading)

            Text(Localization.loginWithSocialNetworksTitle())
                .font(.footnote)
                .foregroundColor(DesignSystem.Color.primaryText())

            VStack(spacing: 12) {
                facebookButton

                CompanyButton(company: Company.google, action: viewModel.loginUsingGoogle)
            }

            HStack {
                Text(Localization.areYouNotRegistered())
                    .font(.footnote)

                NavigationLink(destination: {
                    RegistrationView(viewModel: RegistrationViewModel())
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
                email: viewModel.registrationEmail ?? "",
                fullName: viewModel.registrationName ?? ""
            )
        }
        .onAppear(perform: cleanUp)
        .allowsHitTesting(!viewModel.isLoading)
        .onReceive(viewModel.errorPublisher, perform: showError)
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }

    // MARK: - Components
    private var facebookButton: some View {
        CompanyButton(company: Company.facebook, action: viewModel.loginUsingFacebook, isLoading: $viewModel.isFacebookButtonLoading)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
