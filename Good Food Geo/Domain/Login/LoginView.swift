//
//  LoginView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @State private var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            HeaderView()

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
                            PasswordResetView()
                        }, label: {
                            Text("Forgot?")  // TODO: Localize
                                .foregroundColor(DesignSystem.Color.primary())
                                .font(.footnote)
                                .padding(.trailing)
                        })
                    }
                }
            }

            PrimaryButton(action: {
                login(email: email, password: password)
            }, label: {
                Text(Localization.login())
            })

            Text(Localization.loginWithSocialNetworksTitle())
                .font(.footnote)
                .foregroundColor(DesignSystem.Color.primaryText())

            VStack(spacing: 12) {
                CompanyButton(company: Company.facebook, action: loginWithFacebook)
                CompanyButton(company: Company.google, action: loginWithGoogle)
            }

            HStack {
                Text(Localization.areYouNotRegistered())
                    .font(.footnote)

                NavigationLink(destination: {
                    SignUpView()
                }, label: {
                    Text(Localization.register())
                })
            }
            .padding(.vertical)
        }
        .padding([.horizontal, .bottom], 32)
        .navigationTitle("ავტორიზაცია")  // TODO: Localize
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button("Got It", role: .cancel) { }
        })
    }

    // MARK: - Functions
    private func login(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            showMessage("Email or password should not be empty")  // TODO: Localize
        }
    }

    private func loginWithFacebook() {
        print("loginWithFacebook") 
    }

    private func loginWithGoogle() {
        print("loginWithGoogle")
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
        LoginView()
    }
}
