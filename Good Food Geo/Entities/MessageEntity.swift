//
//  MessageEntity.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 09.01.23.
//

struct MessageEntity: Decodable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message = "msg"
    }
}
