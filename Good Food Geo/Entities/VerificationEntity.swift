//
//  VerificationEntity.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

struct VerificationEntity: Decodable {
    let message: String
    let token: AuthenticationToken

    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case token
    }
}
