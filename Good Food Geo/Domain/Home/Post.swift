//
//  Post.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

struct Post: Identifiable {
    let id: Int
    let description: String
    let imageUrl: String

    static let example = Post(
        id: Int.random(in: 0...10_000),
        description: "Title of the post in main",
        imageUrl: "https://img.freepik.com/free-psd/food-menu-restaurant-social-media-banner-template_120329-1748.jpg"
    )
}
