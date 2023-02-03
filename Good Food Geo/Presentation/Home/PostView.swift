//
//  PostView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct PostView: View {
    let post: Post

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(
                url: URL(string: post.imageUrl),
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                },
                placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .padding()
                }
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(DesignSystem.Color.primary(), lineWidth: 3)
                    .opacity(0.5)
            )

            Text(post.description)
                .multilineTextAlignment(.leading)
                .foregroundColor(DesignSystem.Color.primaryText())
        }
    }
}

// MARK: - Previews
struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .example)
    }
}
