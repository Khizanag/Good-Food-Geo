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
        if viewModel.isLoading {
            VStack {
                ProgressView()
                    .font(.callout)
                    .scaleEffect(2)
                    .offset(y: -36)

            }
        } else {
            bodyWhenDidLoad
        }
    }

    var bodyWhenDidLoad: some View {
        List {
            ForEach(viewModel.posts) { post in
                PostView(post: post)
            }
            .listRowSeparator(.hidden)

            VSpacing(MainTabBarConstant.height)
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
