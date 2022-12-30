//
//  SubSection.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

struct SubSectionView<Content>: View where Content: View {
    struct Model {
        let title: String
        @ViewBuilder var content: () -> Content
    }

    let model: Model

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4){
                Text(model.title)
                    .font(.title3)
                    .bold()

                LinearGradient(gradient: .divider, startPoint: .leading, endPoint: .trailing)
                    .frame(height: 4)
            }

            model.content()
        }
        .padding(.bottom)
    }
}
