//
//  PostsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct HomeView: View {
    let posts = [Post](repeating: .example, count: 10)

    var body: some View {
        ScrollView {
            ZStack {
                Color.white

                VStack {
                    ForEach(posts) { post in
                        PostView(post: post)
                    }
                    .padding([.horizontal, .bottom])
                }
            }

        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
