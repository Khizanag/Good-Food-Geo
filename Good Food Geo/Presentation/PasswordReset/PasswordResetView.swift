//
//  PasswordResetView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct PasswordResetView: View {
    @ObservedObject var viewModel: PasswordResetViewModel

    @State private var email = ""
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


            NavigationLink(destination: {
                RegistrationView(viewModel: RegistrationViewModel())
            }, label: {
                Text(Localization.register())
                    .font(.callout)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(DesignSystem.Color.primary())
                    )
            })


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
            }
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }
}

extension PasswordResetView: MessageDisplayer { }

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel())
    }
}
