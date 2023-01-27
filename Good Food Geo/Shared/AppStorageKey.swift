//
//  AppStorageKey.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

enum AppStorageKey: String {
    static let baseKey = "khizanag.Good-Food-Geo."

    case authenticationToken
    case userInformation
    case language
}

extension AppStorageKey {
    func callAsFunction() -> String {
        AppStorageKey.baseKey + rawValue
    }
}
