//
//  SecondaryButton.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct SecondaryButton<Label>: View where Label: View {
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    var body: some View {
        Button(
            action: action,
            label: {
                label()
                    .foregroundColor(DesignSystem.Color.primaryText())
            }
        )
        .padding()
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(DesignSystem.Color.primary())
        }
        .cornerRadius(15)
    }
}

// MARK: - Previews
struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(action: { }, label: { EmptyView() })
    }
}
