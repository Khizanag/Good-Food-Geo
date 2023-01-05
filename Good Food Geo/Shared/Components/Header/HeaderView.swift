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

    let fullName: String?

    init(viewModel: ViewModel, fullName: String? = nil) {
        self.viewModel = viewModel
        self.fullName = fullName
    }

    var body: some View {
        HStack {
            DesignSystem.Image.appIcon()
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 44)

            Spacer()

            if let fullName {
                Menu("\(Localization.hi()), \(fullName)") {
                    Button("Logout", action: viewModel.logout)
                }
                .foregroundColor(.white)
                .font(.callout)
            }
        }
        .padding(.vertical)
    }
}
