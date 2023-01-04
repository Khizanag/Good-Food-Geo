//
//  UserInformationStorage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import SwiftUI

protocol UserInformationStorage {
    func write(_ userInformation: UserInformationEntity)
    func read() -> UserInformationEntity?
}

struct DefaultUserInformationStorage: UserInformationStorage {
    static let shared = DefaultUserInformationStorage()

    private let key = AppStorageKey.userInformation()

    private init() { }

    func write(_ userInformation: UserInformationEntity) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userInformation), forKey: key)
    }

    func read() -> UserInformationEntity? {
        guard let object = UserDefaults.standard.object(forKey: key),
              let data = object as? Data,
              let decodedObject = try? PropertyListDecoder().decode(UserInformationEntity.self, from: data) else { return nil }
        return decodedObject
    }
}
