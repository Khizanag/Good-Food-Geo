//
//  AboutUsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct AboutUsView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AboutUsViewModel
    
    private let phoneNumber = "+995598935050"
    private let facebookPageUrl = "https://www.facebook.com/TDIG.ge"

    @State private var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        PrimaryPageView(
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
                    VStack(alignment: .leading) {
                        Text("\(Localization.email()): GFGAPK@GMAIL.COM")

                        HStack {
                            Text("\(Localization.phoneNumber()):")
                            Link(phoneNumber, destination: URL(string: "tel:\(phoneNumber)")!)
                        }
                    }
                    .toAnyView()
                })
            ]
        )
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }

    // MARK: - Functions
    @MainActor private func goToFacebookPage() {
        guard let url = URL(string: facebookPageUrl) else {
            showMessage(Localization.facebookUrlIsInvalid())
            return
        }
        UIApplication.shared.open(url)
    }

    private func showMessage(_ message: String, description: String? = nil) {
        alertData.title = message
        if let description {
            alertData.subtitle = description
        }
        alertData.isPresented = true
    }
}

// MARK: - Previews
struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView(viewModel: AboutUsViewModel())
    }
}
