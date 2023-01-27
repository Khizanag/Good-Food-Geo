//
//  CompanyButton.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct CompanyButton: View {
    let company: CompanyModel
    let action: () -> Void
    let title: String?
    let foregroundColor: Color?
    @Binding var isLoading: Bool

    // MARK: - Init
    init(
        company: CompanyModel,
        action: @escaping () -> Void,
        title: String? = nil,
        foregroundColor: Color? = nil,
        isLoading: Binding<Bool> = .constant(false)
    ) {
        self.company = company
        self.action = action
        self.title = title
        self.foregroundColor = foregroundColor
        self._isLoading = isLoading
    }

    // MARK: - Body
    var body: some View {
        Button(action: action, label: {
            if isLoading {
                ProgressView()
            } else {
                ZStack {
                    HStack {
                        company.icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)

                        Spacer()
                    }

                    Text(title ?? company.name)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(foregroundColor ?? .black)
                    #warning("should be fixed foregroundColor")
                }
                .padding(.horizontal)
            }
        })
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(LinearGradient(gradient: Gradient(colors: company.colors), startPoint: .leading, endPoint: .trailing))
        }
    }
}
