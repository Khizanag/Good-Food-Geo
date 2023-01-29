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
    let fullName: String

    @AppStorage(AppStorageKey.language()) private var language: Language = .english
    @State private var accountDeletionSheetIsPresented = false
    
    // MARK: - Body
    var body: some View {
        HStack {
            DesignSystem.Image.appIcon()
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 44)
                .foregroundColor(.blue)
            
            Spacer()

            Menu(content: {
                Menu(content: {
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
                }, label: {
                    Label(Localization.changeLanguage(), systemImage: "globe.europe.africa")
                })

                Button(action: {
                    accountDeletionSheetIsPresented = true
                }, label: {
                    Label(Localization.deleteAccount(), systemImage: "person.2.slash")
                })

                Button(action: {
                    viewModel.logout()
                }, label: {
                    Label(Localization.logout(), systemImage: "figure.walk.motion")
                })
            }, label: {
                Label("\(Localization.hi()), \(fullName)", systemImage: "person")
            })
            .foregroundColor(.white)
            .font(.callout)
            .confirmationDialog(
                Localization.approveAccountDeletionTitle(),
                isPresented: $accountDeletionSheetIsPresented,
                titleVisibility: .visible,
                actions: {
                    Button(role: .destructive, action: {
                        viewModel.deleteAccount()
                    }, label: {
                        Text(Localization.approveAccountDeletionButtonTitle())
                    })
                },
                message: {
                    Text(Localization.approveAccountDeletionDescription())
                }
            )
        }
        .padding(.vertical)
        .disabled(viewModel.isLoading)
    }
}

// MARK: - Previews
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(viewModel: HeaderViewModel(), fullName: "Full Name")
    }
}
