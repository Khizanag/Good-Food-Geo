//
//  FormItemView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct FormItemView: View {
    let model: FormItemModel
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                model.icon
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .foregroundColor(DesignSystem.Color.primary())
                    .frame(width: 32)

                textField
                    .font(.caption)
                    .keyboardType(model.keyboardType)
            }

            HorizontalDivider(color: DesignSystem.Color.primary(), height: 1)
        }
        .frame(height: 48)
    }

    private var textField: some View {
        model.isSecured
            ? AnyView(SecureField(model.placeholder, text: $text))
            : AnyView(TextField(model.placeholder, text: $text))
    }
}

struct FormItemModel: Identifiable {
    let icon: Image
    let placeholder: String
    let isSecured: Bool
    let keyboardType: UIKeyboardType

    var id: String { placeholder }

    init(icon: Image, placeholder: String, isSecured: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.icon = icon
        self.placeholder = placeholder
        self.isSecured = isSecured
        self.keyboardType = keyboardType
    }

    static let example = FormItemModel(icon: DesignSystem.Image.book(), placeholder: "placeholder")
}

struct FormItemView_Previews: PreviewProvider {
    static var previews: some View {
        FormItemView(model: .example, text: .constant(""))
    }
}