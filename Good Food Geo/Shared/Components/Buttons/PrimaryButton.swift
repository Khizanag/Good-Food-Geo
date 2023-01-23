//
//  AppButton.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct PrimaryButton<Label>: View where Label: View {
    let action: () -> Void
    @ViewBuilder var label: () -> Label
    @Binding var isLoading: Bool
    let backgroundColor: Color?

    init(action: @escaping () -> Void, label: @escaping () -> Label, isLoading: Binding<Bool> = .constant(false), backgroundColor: Color? = nil) {
        self._isLoading = isLoading
        self.action = action
        self.label = label
        self.backgroundColor = backgroundColor
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(DesignSystem.Color.buttonTitle())
                }
            }
        )
        .disabled(isLoading)
        .padding()
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background {
            if let backgroundColor {
                backgroundColor
            } else {
                LinearGradient(gradient: .primary, startPoint: .leading, endPoint: .trailing)
            }
        }
        .cornerRadius(15)
    }
}

// MARK: - Previews
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(action: { }, label: { EmptyView() })
    }
}
