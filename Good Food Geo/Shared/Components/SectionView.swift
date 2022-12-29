//
//  Section.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct SectionView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.title)

            LinearGradient(gradient: .divider, startPoint: .leading, endPoint: .trailing)
                .rotationEffect(.degrees(180))
                .frame(height: 4)

            Text(description)
                .font(.callout)
                .foregroundColor(.white)
        }
        .padding(.vertical)
    }
}

extension SectionView {
    struct Model {
        let title: String
        let description: String
    }
}
