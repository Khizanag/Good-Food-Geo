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

    // MARK: - Events
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
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = true
            }

            let result = await postsRepository.posts()

            switch result {
            case .success(let posts):
                DispatchQueue.main.async { [weak self] in
                    self?.posts = posts
                }
            case .failure(let error):
                eventPublisher.send(.showError(error))
            }

            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
        }
    }
}
