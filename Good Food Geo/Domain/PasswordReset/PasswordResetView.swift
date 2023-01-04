//
//  PasswordResetView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct PasswordResetView: View {
    @State private var email = ""

    @State private var alertData = AlertData()

    var body: some View {
        VStack {

            Spacer()

            Text(Localization.enterEmailAddress())
                .multilineTextAlignment(.center)

            PrimaryTextField(text: $email, placeholder: Localization.passwordResetEmailPlaceholder())

            PrimaryButton(action: {

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
                Text(Localization.signUp())
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
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }

    // MARK: - Show Message
    private func showMessage(_ message: String, description: String? = nil) {
        alertData.title = message
        if let description {
            alertData.subtitle = description
        }
        alertData.isPresented = true
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
