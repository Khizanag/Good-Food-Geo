//
//  PrimaryPageView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct PrimaryPageView: View {
    let section: SectionView.Model
    let subSections: [SubSectionView<AnyView>.Model]

    @Environment(\.dismiss) var dismiss

    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared

    var body: some View {
        ZStack {
            LinearGradient.background
                .edgesIgnoringSafeArea([.top])


            VStack {
                VStack {
                    let headerViewModel = HeaderViewModel()
                    HeaderView(viewModel: headerViewModel, fullName: userInformationStorage.read()?.fullName)
                        .onReceive(headerViewModel.eventPublisher) { event in
                            switch event {
                            case .shouldLogout:
                                withAnimation {
                                    dismiss()
                                }
                            }
                        }
                        .ignoresSafeArea(.container, edges: .bottom)

                    SectionView(title: section.title, description: section.description)
                }
                .padding(.horizontal, 32)

                ZStack {
                    Color.white
                        .cornerRadius(32, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()

                    VStack {
                        ScrollView {
                            VSpacing(8)

                            ForEach(subSections, id: \.title) { model in
                                SubSectionView(model: model)
                            }
                        }
                        .scrollIndicators(.hidden)
                        .padding(1)
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}

// MARK: - Previews
struct StaticPage_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryPageView(
            section: .init(title: "Title", description: "Description"),
            subSections: (0...2).map { index in
                SubSectionView.Model(title: "Section Title \(index)", content: {
                    ForEach(0...index, id: \.self) { subindex  in
                        Label("Title \(subindex)", image: "clock")
                    }
                    .toAnyView()
                })
            }
        )
    }
}
