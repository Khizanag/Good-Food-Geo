//
//  AboutUsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct AboutUsView: View {
    private let phoneNumber = "+995598935050"
    private let facebookPageUrl = "https://www.facebook.com/TDIG.ge"
    private let email = "tdig.org@gmail.com"

    var body: some View {
        StaticPage(
            section: .init(title: Localization.aboutUs(), description: Localization.aboutUsDescription()),
            subSections: [
                SubSectionView.Model(title: Localization.aboutUsSectionTitle(), content: {
                    AnyView(
                        VStack(alignment: .leading) {
                            Text(Localization.aboutUsSectionDescription())
                                .font(.body)

                            CompanyButton(company: Company.facebook, action: {
                                goToFacebookPage()
                            })
                        }
                    )
                }),
                SubSectionView.Model(title: Localization.contactUs(), content: {
                    AnyView(
                        VStack(alignment: .leading) {
                            Text("\(Localization.email()): \(email.uppercased())")

                            HStack {
                                Text("\(Localization.phoneNumber()):")
                                Link(phoneNumber, destination: URL(string: "tel:\(phoneNumber)")!)
                            }
                        }
                    )
                })
            ]
        )
    }

    // MARK: - Functions
    private func goToFacebookPage() {
        guard let url = URL(string: facebookPageUrl) else {
            showMessage("Facebook page link is no longer valid.")
            return
        }
        UIApplication.shared.open(url)
    }

    private func showMessage(_ message: String) {
        print(message)
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
