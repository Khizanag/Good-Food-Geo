//
//  StaticPage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct StaticPage: View {
    let section: SectionView.Model
    let subSections: [SubSectionView<AnyView>.Model]

    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared

    var body: some View {
        ZStack {
            LinearGradient.background
                .edgesIgnoringSafeArea([.top])

            VStack {
                VStack {
                    HeaderView(fullName: userInformationStorage.read()?.fullName)

                    SectionView(title: section.title, description: section.description)
                }
                .padding(.horizontal, 32)

                ZStack {
                    Color.white
                        .cornerRadius(44, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()

                    VStack {
                        ForEach(subSections, id: \.title) { model in
                            SubSectionView(model: model)
                        }

                        Spacer()
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}
