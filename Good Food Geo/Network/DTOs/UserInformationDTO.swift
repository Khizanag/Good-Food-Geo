//
//  UserInformationDTO.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

struct UserInformationDTO: Decodable {
    let email: String
    let name: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case email
        case name
        case phoneNumber = "phone_number"
    }
}
