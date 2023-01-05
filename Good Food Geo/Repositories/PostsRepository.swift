//
//  PostsRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

protocol PostsRepository {
    func getPosts() async -> Result<[Post], AppError>
}

struct DefaultPostsRepository: PostsRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func getPosts() async -> Result<[Post], AppError> {
        var request = URLRequest(url: EndPoint.feed.fullUrl)
        request.setMethod(.get)

        let result = await networkLayer.execute([PostDTO].self, using: request)

        switch result {
        case .success(let postDtos):
            return .success(postDtos.map { dto in
                Post(id: dto.idd, description: dto.text, imageUrl: dto.image)
            })
        case .failure(let error):
            return .failure(error)
        }
    }
}
