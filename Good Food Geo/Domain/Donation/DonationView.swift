//
//  DonationView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct DonationView: View {
    private let banks: [(CompanyModel, String)] = [
        (Company.bog, "GE54TB7337945064300021"),
        (Company.tbc, "GE54TB7337945064300021"),
        (Company.liberty, "GE54TB7337945064300021")
    ]

    var body: some View {
        StaticPage(
            section: .init(title: "დონაციის შესახებ", description: "ნებისმიერ მსურველს აქვს შესაძლებლობა გააკეთოს ფინანსური შემოწირულობა და დააფინანსოს აპლიკაციის მუშაობა მომხმარებელთა საკეთილდღეოდ."),
            subSections: [
                .init(title: "საბანკო ანგარიშის ნომერი", content: {
                    AnyView(
                        VStack {
                            ForEach(banks, id: \.0.name) { bank, iban in
                                BankButton(company: bank, iban: iban) {
                                    print("print from donation")
                                }
                            }
                        }
                    )
                })
            ])
    }
}

struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView()
    }
}
