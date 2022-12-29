//
//  Header.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct HeaderView: View {
    let name: String?
    let surname: String?

    init(name: String? = nil, surname: String? = nil) {
        self.name = name
        self.surname = surname
    }

    var body: some View {
        HStack {
            DesignSystem.Image.appIcon()
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 44)

            Spacer()

            if let name, let surname {
                Text("\(Localization.hi()), \(name) \(surname)")
                    .foregroundColor(.white)
                    .font(.callout)
            }
        }
        .padding(.vertical)
    }
}
