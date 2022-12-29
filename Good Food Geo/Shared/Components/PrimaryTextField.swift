//
//  PrimaryTextField.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct PrimaryTextField: View {
    @Binding var text: String
    let placeholder: String

    // MARK: - Body
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
        }
        .padding(.leading)
        .frame(height: 50)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(DesignSystem.Color.primary())
        }
    }
}

// MARK: - Previews
struct PrimaryTextField_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryTextField(text: .constant(""), placeholder: "")
    }
}
