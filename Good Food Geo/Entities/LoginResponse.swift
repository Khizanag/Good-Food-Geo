//
//  LoginEntity.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

struct LoginResponse: Decodable {
    let token: AuthenticationToken
    let message: String

    enum CodingKeys: String, CodingKey {
        case token
        case message = "msg"
    }
}
