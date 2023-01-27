//
//  Header.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct HeaderView: View {
    typealias ViewModel = HeaderViewModel

    @ObservedObject var viewModel: ViewModel
    @AppStorage(AppStorageKey.language()) private var language: Language = .english

    let fullName: String?

    // MARK: - Init
    init(viewModel: ViewModel, fullName: String? = nil) {
        self.viewModel = viewModel
        self.fullName = fullName
    }

    // MARK: - Body
    var body: some View {
        HStack {
            DesignSystem.Image.appIcon()
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 44)
                .foregroundColor(.blue)

            Spacer()

            if let fullName {
                Menu(content: {
                    Menu(Localization.changeLanguage()) {
                        ForEach(Language.allCases, id: \.localizableIdentifier) { language in
                            Button(action: {
                                viewModel.changeLanguage(to: language)
                            }, label: {
                                let title = "\(language.icon) \(language.name)"

                                if language == self.language {
                                    Label(title, systemImage: "checkmark")
                                } else {
                                    Text(title)
                                }
                            })
                        }
                    }
                    Button(Localization.logout(), action: viewModel.logout)
                }, label: {
                    Label("\(Localization.hi()), \(fullName)", systemImage: "person")
                })
                .foregroundColor(.white)
                .font(.callout)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Previews
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(viewModel: HeaderViewModel(), fullName: "Full Name")
    }
}
