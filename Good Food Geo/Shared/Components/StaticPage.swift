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

    var body: some View {
        ZStack {
            LinearGradient.background
                .edgesIgnoringSafeArea([.top])

            VStack {
                VStack {
                    HeaderView(name: "Giga", surname: "Khizanishvili") // TODO: change with real info

                    SectionView(title: section.title, description: section.description)
                }
                .padding(.horizontal, 32)

                ZStack {
                    Color.white
                        .cornerRadius(44, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()

                    VStack {
                        ForEach(subSections) { model in
                            SubSectionView(model: model)
                        }

                        Spacer()
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 32)
                }
            }
            .edgesIgnoringSafeArea([]) // FIXME: remove
        }
    }
}
