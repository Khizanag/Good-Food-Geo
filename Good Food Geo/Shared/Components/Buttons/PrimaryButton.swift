//
//  AppButton.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct PrimaryButton<Label>: View where Label: View {
    @Binding var isLoading: Bool
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    init(action: @escaping () -> Void, label: @escaping () -> Label, isLoading: Binding<Bool> = .constant(false)) {
        self._isLoading = isLoading
        self.action = action
        self.label = label
    }

    // MARK: - Body
    var body: some View {
        Button(
            action: action,
            label: {
                if isLoading {
                    ProgressView()
                } else {
                    label()
                        .foregroundColor(DesignSystem.Color.buttonTitle())
                }
            }
        )
        .padding()
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: .primary, startPoint: .leading, endPoint: .trailing))
        .cornerRadius(15)
    }
}

// MARK: - Previews
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(action: { }, label: { EmptyView() })
    }
}
