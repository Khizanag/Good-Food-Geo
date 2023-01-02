//
//  RegistrationResponse.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

struct RegistrationResponse: Decodable {
    let email: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case message = "msg"
    }
}
