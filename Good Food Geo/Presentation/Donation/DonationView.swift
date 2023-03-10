//
//  DonationView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct DonationView: View {
    // MARK: - Properties
    @StateObject var viewModel: DonationViewModel

    private let banks: [(bank: CompanyModel, accountNumber: String)] = [
        (Company.bog, "GE54TB7337945064300021"),
        (Company.tbc, "GE54TB7337945064300021"),
        (Company.liberty, "GE54TB7337945064300021")
    ]

    @State private var isSharePresented = false

    // MARK: - Body
    var body: some View {
        PrimaryPageView(
            section: .init(
                title: Localization.aboutDonationSectionTitle(),
                description: Localization.aboutDonationSectionDescription()
            ),
            subSections: [
                .init(title: Localization.donationBankAccountNumber(), content: {
                    VStack {
                        ForEach(banks, id: \.bank.name) { bank, accountNumber in
                            BankButton(company: bank, accountNumber: accountNumber) {
                                isSharePresented = true
                            }
                            .sheet(isPresented: $isSharePresented, content: {
                                ActivityViewController(activityItems: [accountNumber])
                            })
                        }
                    }
                    .toAnyView()
                }),
                .init(title: Localization.receiver(), content: {
                    Menu {
                        Button(action: {
                            UIPasteboard.general.string = Localization.receiverValue()
                        }, label: {
                            Label(Localization.copy(), systemImage: "doc.on.doc.fill")
                        })
                    } label: {
                        Text(Localization.receiverValue())
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                    }
                    .toAnyView()
                }),
                .init(title: Localization.purpose(), content: {
                    Menu {
                        Button(action: {
                            UIPasteboard.general.string = Localization.purposeValue()
                        }, label: {
                            Label(Localization.copy(), systemImage: "doc.on.doc.fill")
                        })
                    } label: {
                        Text(Localization.purposeValue())
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                    }
                    .toAnyView()
                })
            ]
        )
    }
}

// MARK: - Previews
struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView(viewModel: DonationViewModel())
    }
}
