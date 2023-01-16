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

    private let receiver = "ა(ა)იპ საქართველოს ტრენინგებისა და განვითარების ინსტიტუტი"
    private let purpose = "დონაცია/ქველმოქმედება"

    @State private var isSharePresented = false

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                StaticPage(
                    section: .init(title: Localization.aboutDonationSectionTitle(), description: Localization.aboutDonationSectionDescription()),
                    subSections: [
                        .init(title: Localization.donationBankAccountNumber(), content: {
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
                            .toAnyView()
                        }),
                        .init(title: "მიმღები", content: {
                            Menu {
                                Button(action: {
                                    UIPasteboard.general.string = receiver
                                }, label: {
                                    Label("Copy", systemImage: "doc.on.doc.fill")
                                })
                            } label: {
                                Text(receiver)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                            }
                            .toAnyView()
                        }),
                        .init(title: "დანიშნულება", content: {
                            Menu {
                                Button(action: {
                                    UIPasteboard.general.string = purpose
                                }, label: {
                                    Label("Copy", systemImage: "doc.on.doc.fill")
                                })
                            } label: {
                                Text(purpose)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                            }
                            .toAnyView()
                        })
                    ]
                )

                VSpacing(16)
            }
        }
    }
}

// MARK: - Previews
struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView()
    }
}