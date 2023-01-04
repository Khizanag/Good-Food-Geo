//
//  AuthenticationTokenStorage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import SwiftUI // @State

protocol AuthenticationTokenStorage {
    func read() -> AuthenticationToken?
    func write(_ token: AuthenticationToken)
    func delete()
}

struct DefaultAuthenticationTokenStorage: AuthenticationTokenStorage {
//    @KeychainStorage("khizanag.Good-Food-Geo.authenticationToken")
    @State private var value: AuthenticationToken?

    static let shared = DefaultAuthenticationTokenStorage()

    private init() { }

    func read() -> AuthenticationToken? {
        value
    }

    func write(_ token: AuthenticationToken) {
        value = token
        print("tokens new value is written")
    }

    func delete() {
        value = nil
    }
}
