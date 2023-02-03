//
//  PasswordResetView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct PasswordResetView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: PasswordResetViewModel

    @State private var email = ""
    @State private var shouldNavigateToRegistration = false
    @State var fullNameForRegistration = ""
    @State var emailForRegistration = ""

    @FocusState private var isFieldFocused

    @State private var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()

            Text(Localization.enterEmailAddress())
                .multilineTextAlignment(.center)

            PrimaryTextField(text: $email, placeholder: Localization.passwordResetEmailPlaceholder())
                .focused($isFieldFocused)

            PrimaryButton(action: {
                viewModel.resetPassword(for: email)
            }, label: {
                Text(Localization.send())
            })

            Spacer()

            Text(Localization.passwordResetNoAccount())
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.footnote)

            PrimaryButton(
                action: {
                    shouldNavigateToRegistration = true
                },
                label: {
                    Text(Localization.register())
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(DesignSystem.Color.primary())
                        )
                },
                backgroundColor: .white
            )

            Spacer()
        }
        .padding()
        .navigationTitle(Localization.passwordResetTitle())
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(viewModel.eventPublisher) { event in
            switch event {
            case .cleanUpEmailField:
                isFieldFocused = false
                email = ""
            case .showMessage(let message):
                showMessage(message)
            case .dismiss:
                dismiss()
            }
        }
        .navigationDestination(isPresented: $shouldNavigateToRegistration) {
            RegistrationView(
                viewModel: RegistrationViewModel(),
                fullName: $fullNameForRegistration,
                email: $emailForRegistration
            )
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
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
struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel())
    }
}
