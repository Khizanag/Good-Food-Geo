//
//  BankButton.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct BankButton: View {
    let company: CompanyModel
    let accountNumber: String
    let action: () -> Void

    // MARK: - Body
    var body: some View {
        CompanyButton(
            company: company,
            action: action,
            title: accountNumber,
            foregroundColor: .black
        )
        .font(.footnote)
    }
}

// MARK: - Previews
struct BankButton_Previews: PreviewProvider {
    static var previews: some View {
        BankButton(company: Company.liberty, accountNumber: "", action: { })
    }
}
