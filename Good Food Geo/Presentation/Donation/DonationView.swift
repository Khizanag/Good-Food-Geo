//
//  DonationView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct DonationView: View {
    // MARK: - Properties
    private let banks: [(CompanyModel, String)] = [
        (Company.bog, "GE54TB7337945064300021"),
        (Company.tbc, "GE54TB7337945064300021"),
        (Company.liberty, "GE54TB7337945064300021")
    ]

    @State private var isSharePresented = false

    // MARK: - Body
    var body: some View {
        StaticPage(
            section: .init(title: Localization.aboutDonationSectionTitle(), description: Localization.aboutDonationSectionDescription()),
            subSections: [
                .init(title: Localization.donationBankAccountNumber(), content: {
                    AnyView(
                        VStack {
                            ForEach(banks, id: \.0.name) { bank, accountNumber in
                                BankButton(company: bank, accountNumber: accountNumber) {
                                    isSharePresented = true
                                }
                                .sheet(isPresented: $isSharePresented, content: {
                                    ActivityViewController(activityItems: [accountNumber])
                                })
                            }
                        }
                    )
                })
            ])
    }
}

// MARK: - Previews
struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView()
    }
}
