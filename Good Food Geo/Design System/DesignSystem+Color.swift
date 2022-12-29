//
//  DesignSystem+Color.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

extension DesignSystem {
    enum Color: String {
        case primary
        case secondary
        case negative
        case primaryText
        case secondaryText
        case primaryGradientLight
        case primaryGradientDark
        case placeholder
        case buttonTitle
        case buttonBasic
        case buttonImportant
    }
}

extension DesignSystem.Color {
    func callAsFunction() -> Color {
        Color(name)
    }

    private var name: String { rawValue }
}
