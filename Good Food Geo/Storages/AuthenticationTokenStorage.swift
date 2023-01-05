//
//  AuthenticationTokenStorage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import SwiftUI

protocol AuthenticationTokenStorage {
    func read() -> String?
    func write(_ token: String)
    func delete()
}

struct DefaultAuthenticationTokenStorage: AuthenticationTokenStorage {
    static let shared = DefaultAuthenticationTokenStorage()

    private static let key = AppStorageKey.authenticationToken()
    @AppStorage(key) private var value: String?

    // MARK: - Init
    private init() { }

    func read() -> String? {
        value
    }

    func write(_ token: String) {
        value = token
        print("tokens new value is written")
    }

    func delete() {
        value = nil
    }
}
