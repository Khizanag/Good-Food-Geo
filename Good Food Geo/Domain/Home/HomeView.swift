//
//  PostsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        List {
            ForEach(viewModel.posts) { post in
                PostView(post: post)
            }
            .listRowSeparator(.hidden)

            VSpacing(HomeTabBarConstant.height)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
