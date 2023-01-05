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

    @Environment(\.dismiss) var dismiss

    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared
    private let headerViewModel = HeaderViewModel()

    var body: some View {
        ZStack {
            LinearGradient.background
                .edgesIgnoringSafeArea([.top])

            VStack {
                VStack {
                    HeaderView(viewModel: headerViewModel, fullName: userInformationStorage.read()?.fullName)
                        .onReceive(headerViewModel.eventPublisher) { event in
                            switch event {
                            case .shouldLogout:
                                withAnimation {
                                    dismiss()
                                }
                            }
                        }

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
