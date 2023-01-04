//
//  AppStorageKey.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Foundation

enum AppStorageKey: String {
    static let baseKey = "khizanag.Good-Food-Geo."

    case authenticationToken
}

extension AppStorageKey {
    func callAsFunction() -> String {
        AppStorageKey.baseKey + rawValue
    }
}
