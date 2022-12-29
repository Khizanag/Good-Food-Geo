//
//  DesignSystem+Image.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import Foundation
import SwiftUI

extension DesignSystem {
    enum Image: String {
        case appIcon
        case book
        case creditCard = "creditcard"
        case email = "envelope"
        case example = "food"
        case facebookLogo
        case fingerprint = "touchid"
        case googleLogo
        case house
        case location = "location.circle"
        case lock
        case lockOpened = "lock.open"
        case pencil
        case person
        case phone
        case qr = "qrcode.viewfinder"
        case bog
        case liberty
        case tbc
    }
}

extension DesignSystem.Image {
    func callAsFunction() -> Image {
        imageExists(named: name) ? Image(name) : Image(systemName: name)
    }

    private func imageExists(named name: String) -> Bool {
        UIImage(named: name) != nil
    }

    private var name: String { rawValue }
}
