//
//  BankButton.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct BankButton: View {
    let company: CompanyModel
    let iban: String
    let action: () -> Void

    var body: some View {
        CompanyButton(
            company: company,
            action: action,
            title: iban,
            foregroundColor: .black
        )
        .font(.footnote)
    }
}

struct BankButton_Previews: PreviewProvider {
    static var previews: some View {
        BankButton(company: Company.liberty, iban: "", action: { })
    }
}
