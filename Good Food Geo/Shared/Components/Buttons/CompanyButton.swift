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

    // MARK: - Init
    init(company: CompanyModel, action: @escaping () -> Void, title: String? = nil) {
        self.company = company
        self.action = action
        self.title = title
    }

    // MARK: - Body
    var body: some View {
        Button(action: action, label: {
            ZStack {
                HStack {
                    company.icon()
                        .resizable()
                        .frame(width: 32, height: 32)

                    Spacer()
                }

                Text(title ?? company.name)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
        })
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(LinearGradient(gradient: Gradient(colors: company.colors), startPoint: .leading, endPoint: .trailing))
        }
    }
}
