//
//  PostsRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

protocol PostsRepository {
    func getPosts() async -> [Post]
}

struct DefaultPostsRepository: PostsRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func getPosts() async -> [Post] {
        var request = URLRequest(url: EndPoint.feed.fullUrl)
        request.setMethod(.get)

        guard let postDtos = await networkLayer.execute([PostDTO].self, using: request) else { return [] }
        let posts: [Post] = postDtos.map { dto in
            Post(id: dto.idd, description: dto.text, imageUrl: dto.image)
        }

        return posts
    }
}
