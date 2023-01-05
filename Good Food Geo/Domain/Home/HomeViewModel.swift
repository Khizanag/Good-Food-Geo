//
//  HomeViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private let postsRepository: PostsRepository = DefaultPostsRepository()

    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false

    enum Event {
        case showError(AppError)
    }

    let eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Init
    init() {
        fetchPosts()
    }

    func refresh() {
        fetchPosts()
    }

    // MARK: - Private
    private func fetchPosts() {
        Task {
            isLoading = true
            switch await postsRepository.getPosts() {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                eventPublisher.send(.showError(error))
            }
            isLoading = false
        }
    }
}
