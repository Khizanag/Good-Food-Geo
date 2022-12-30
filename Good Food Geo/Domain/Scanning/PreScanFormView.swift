//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct PreScanFormView: View {
    @State private var fullName = ""
    @State private var idNumber = ""
    @State private var comment = ""
    @State private var location = ""

    @State private var userAgreesTerms = false

    var body: some View {
        ScrollView {
            VStack {
                Text(Localization.preScanFormTitle().uppercased())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()

                FormItemView(model: FormItemModel(icon: DesignSystem.Image.person(), placeholder: Localization.fullName()), text: $fullName)
                FormItemView(model: FormItemModel(icon: DesignSystem.Image.fingerprint(), placeholder: Localization.idNumber(), keyboardType: .numberPad), text: $idNumber)
                FormItemView(model: FormItemModel(icon: DesignSystem.Image.pencil(), placeholder: Localization.comment()), text: $comment)
                FormItemView(model: FormItemModel(icon: DesignSystem.Image.location(), placeholder: Localization.location()), text: $location)

                Toggle(isOn: $userAgreesTerms) {
                    Text(Localization.acceptTerms())
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(DesignSystem.Color.secondaryText())
                        .multilineTextAlignment(.trailing)
                }
                .tint(DesignSystem.Color.primary())
                .padding()

                Button(action: {
                    print("Start product scanning")
                }, label: {
                    DesignSystem.Image.qr()
                        .imageScale(.large)

                    Text(Localization.scanProduct())
                })
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(DesignSystem.Color.buttonTitle())
                .background(DesignSystem.Color.buttonImportant())
                .cornerRadius(12)
            }
            .padding(32)
        }
    }
}

struct PreScanFormView_Previews: PreviewProvider {
    static var previews: some View {
        PreScanFormView()
    }
}
