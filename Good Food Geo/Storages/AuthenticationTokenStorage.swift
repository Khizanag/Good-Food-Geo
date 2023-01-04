//
//  AuthenticationTokenStorage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import SwiftUI // @State

protocol AuthenticationTokenStorage {
    func read() -> String?
    func write(_ token: String)
    func delete()
}

struct DefaultAuthenticationTokenStorage: AuthenticationTokenStorage {
    private static let key: String = "khizanag.Good-Food-Geo.authenticationToken"
    @AppStorage(key) private var value: String?

    static let shared = DefaultAuthenticationTokenStorage()

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
