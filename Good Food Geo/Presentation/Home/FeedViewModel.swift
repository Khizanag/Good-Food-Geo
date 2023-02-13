//
//  HomeViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    private let postsRepository: PostsRepository = DefaultPostsRepository()

    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    var postsAreFetched = false

    // MARK: - Events
    enum Event {
        case showError(AppError)
    }

    let eventPublisher = PassthroughSubject<Event, Never>()

    func refresh() {
        fetchPosts()
    }

    func fetchPostsIfNeeded() {
        if !postsAreFetched {
            fetchPosts()
        }
    }

    // MARK: - Private
    private func fetchPosts() {
        Task { @MainActor in
            isLoading = true

            let result = await postsRepository.posts()

            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                eventPublisher.send(.showError(error))
            }

            isLoading = false
            postsAreFetched = true
        }
    }
}
