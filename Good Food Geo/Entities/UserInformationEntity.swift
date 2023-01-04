//
//  UserInformationEntity.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

struct UserInformationEntity: Codable {
    typealias RawValue = String

    let email: String
    let fullName: String
    let phoneNumber: String
}
