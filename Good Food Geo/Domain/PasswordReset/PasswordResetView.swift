//
//  PasswordResetView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct PasswordResetView: View {
    @State private var email = ""

    var body: some View {
        VStack {

            Spacer()

            Text(Localization.enterEmailAddress())
                .multilineTextAlignment(.center)

            PrimaryTextField(text: $email, placeholder: Localization.passwordResetEmailPlaceholder())

//            HStack {
//                NavigationLink(destination: {
//                    LoginView()
//                }, label: {
//                    Text("ავტორიზაციაზე დაბრუნება")
//                })
//            }

            PrimaryButton(action: {

            }, label: {
                Text(Localization.send())
            })

            Spacer()

            Text(Localization.passwordResetNoAccount())
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.footnote)

            SecondaryButton(action: {

            }, label: {
                Text(Localization.signUp())
                    .font(.callout)
            })

            Spacer()
        }
        .padding()
        .navigationTitle(Localization.passwordResetTitle())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
