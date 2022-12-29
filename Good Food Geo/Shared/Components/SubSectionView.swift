//
//  SubSection.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct SubSectionView<Content>: View where Content: View {
    struct Model: Identifiable {
        let title: String
        @ViewBuilder var content: () -> Content

        var id: String { title }
    }

    let model: Model

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.title2)
                .bold()

            LinearGradient(gradient: .divider, startPoint: .leading, endPoint: .trailing)
                .frame(height: 4)

            model.content()
        }
        .padding(.vertical)
    }
}
