//
//  Header.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct HeaderView: View {
    let fullName: String?

    init(fullName: String? = nil) {
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
                Text("\(Localization.hi()), \(fullName)")
                    .foregroundColor(.white)
                    .font(.callout)
            }
        }
        .padding(.vertical)
    }
}
