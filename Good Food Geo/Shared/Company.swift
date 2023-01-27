//
//  Company.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 29.12.22.
//

import SwiftUI

#warning("Fix enum Company and CompanyModel problem")
enum Company {
    static let bog = CompanyModel(
        name: "Bank of Georgia",
        icon: DesignSystem.Image.bogLogo(),
        colors: [
            Color(hex: 0xFC671A)
        ]
    )

    static let tbc = CompanyModel(
        name: "TBC Bank",
        icon: DesignSystem.Image.tbcLogo(),
        colors: [
            Color(hex: 0x00AEEF)
        ]
    )

    static let liberty = CompanyModel(
        name: "Liberty Bank",
        icon: DesignSystem.Image.libertyLogo(),
        colors: [
            Color(hex: 0x000000), Color(hex: 0xFF0000)
        ]
    )

    static let facebook = CompanyModel(
        name: "Facebook",
        icon: DesignSystem.Image.facebookLogo(),
        colors: [
            Color(hex: 0x4285F4)
        ]
    )

    static let google = CompanyModel(
        name: Localization.google(),
        icon: DesignSystem.Image.googleLogo(),
        colors: [
            Color(hex: 0xEA4335),
            Color(hex: 0xFBBC05),
            Color(hex: 0x4A853),
            Color(hex: 0x285F4)
        ]
    )
}

// MARK: - Model
struct CompanyModel {
    let name: String
    let icon: Image
    let colors: [Color]
}
