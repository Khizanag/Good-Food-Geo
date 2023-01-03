//
//  KeychainStorage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 03.01.23.
//

import SwiftUI
import KeychainAccess

/// Source: https://medium.com/@ihamadfuad/swiftui-keychain-as-property-wrapper-ca60812e0e5e

@propertyWrapper
struct KeychainStorage<T: Codable>: DynamicProperty {
    // MARK: - Wrapped Value
    var wrappedValue: Value? {

        get  { value }

        nonmutating set {

            value = newValue

            do {

                let encoded = try JSONEncoder().encode(value)
                try Keychain().set(encoded, key: key)

            } catch let error {

                try? Keychain().remove(key)
            }
        }
    }

    // MARK: - Projected Value
    var projectedValue: Binding<Value?> {
        Binding(
            get: {
                wrappedValue
            },
            set: {
                wrappedValue = $0
            }
        )
    }


    typealias Value = T

    let key: String

    @State private var value: Value?

    // MARK: - Init
    init(wrappedValue: Value? = nil, _ key: String) {

        self.key = key

        var initialValue = wrappedValue

        do {

            try Keychain().get(key) { attributes in

                if let attributes = attributes,
                   let data = attributes.data {

                    do {
                        let decoded = try JSONDecoder().decode(Value.self, from: data)
                        initialValue = decoded
                    } catch let error {
                        print("[KeychainStorage] Keychain().get(\(key)) - \(error.localizedDescription)")
                    }
                }
            }
        } catch let error {
            fatalError("\(error)")
        }

        self._value = State<Value?>(initialValue: initialValue)
    }
}
