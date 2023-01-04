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
    @Published var isLoading: Bool = false

    // MARK: - Init
    init() {
        fetchPosts()
    }

    // MARK: - Private
    private func fetchPosts() {
        Task {
            isLoading = true
            posts = await postsRepository.getPosts()
            isLoading = false
        }
    }
}
