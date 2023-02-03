//
//  PostsRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

protocol PostsRepository {
    func posts() async -> Result<[Post], AppError>
}

struct DefaultPostsRepository: PostsRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func posts() async -> Result<[Post], AppError> {
        var request = URLRequest(url: EndPoint.feed.fullUrl)
        request.setMethod(.get)

        let result = await networkLayer.execute([PostDTO].self, using: request)

        switch result {
        case .success(let posts):
            return .success(posts.map { post in
                Post(id: post.idd, description: post.text, imageUrl: post.image)
            })
        case .failure(let error):
            return .failure(error)
        }
    }
}
