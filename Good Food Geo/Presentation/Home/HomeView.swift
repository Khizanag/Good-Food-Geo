//
//  PostsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    // MARK: - Body
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .font(.callout)
                    .scaleEffect(2)
                    .offset(y: -36)
            } else {
                bodyWhenDidLoad
            }
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
        .refreshable {
            viewModel.refresh()
        }
    }
}

// MARK: - Previews
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
