//
//  PostView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct PostView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                post.image
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .cornerRadius(8)

                RoundedRectangle(cornerRadius: 8)
                    .stroke(DesignSystem.Color.primary(), lineWidth: 3)
                    .opacity(0.5)
            }

            Text(post.description)
                .multilineTextAlignment(.leading)
                .foregroundColor(DesignSystem.Color.primaryText())
        }
    }
}

struct Post: Identifiable {
    let id: UUID
    let description: String
    let image: Image

    static let example = Post(id: UUID(), description: "Title of the post in main", image: DesignSystem.Image.example())
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .example)
    }
}
