//
//  RegistrationTermsAndConditionsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.01.23.
//

import SwiftUI

struct RegistrationTermsAndConditionsView: View {
    @Binding var userAgreesTerms: Bool
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text(Localization.termsAndConditionsTitle())
                    .font(.title)
                    .bold()

                VStack(alignment: .leading, spacing: 8) {
                    Text(Localization.privacyPolicyTitle())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .italic()

                    Text(Localization.privacyPolicyDescription())
                        .font(.body)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(Localization.termsAndConditionsSectionsTitle())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .italic()

                    VStack(alignment: .leading, spacing: 4) {
                        Text(Localization.termsAndConditionsFirstSection())
                            .font(.body)
                        Text(Localization.termsAndConditionsSecondSection())
                            .font(.body)
                    }
                }

                VStack {
                    PrimaryButton(
                        action: {
                            userAgreesTerms = true
                            isPresented = false
                        },
                        label: { Text(Localization.agree()) },
                        backgroundColor: .green.opacity(0.85)
                    )

                    PrimaryButton(
                        action: {
                            isPresented = false
                        },
                        label: { Text(Localization.close()) },
                        backgroundColor: .red.opacity(0.85)
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Previews
struct RegistrationTermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationTermsAndConditionsView(userAgreesTerms: .constant(true), isPresented: .constant(false))
    }
}
