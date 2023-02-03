//
//  Header.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - Properties
    @AppStorage(AppStorageKey.language()) private var language: Language = .default

    @ObservedObject var viewModel: HeaderViewModel

    let fullName: String

    @State private var accountDeletionSheetIsPresented = false

    @State var alertData = AlertData()
    
    // MARK: - Body
    var body: some View {
        HStack {
            DesignSystem.Image.appIcon()
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 44)
                .foregroundColor(.blue)
            
            Spacer()

            profileMenu
        }
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
        .onReceive(viewModel.errorPublisher, perform: showError)
        .onReceive(viewModel.eventPublisher) { event in
            switch event {
            case .shouldLogout:
                break
            case .showMessage(let message):
                showMessage(message)
            }
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
        .padding(.vertical)
        .disabled(viewModel.isLoading)
    }

    // MARK: - Components
    private var profileMenu: some View {
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
    }

    // MARK: - Message Displayer
    private func showError(_ error: AppError) {
        showMessage(error.description)
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
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(viewModel: HeaderViewModel(), fullName: "Full Name")
    }
}
