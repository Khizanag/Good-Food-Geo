//
//  HomeViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let postsRepository: PostsRepository = DefaultPostsRepository()

    @Published var posts: [Post] = []

    // MARK: - Init
    init() {
        fetchPosts()
    }

    // MARK: - Private
    private func fetchPosts() {
        Task {
            posts = await postsRepository.getPosts()
        }
    }
}
