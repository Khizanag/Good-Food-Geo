//
//  Gradient+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

extension Gradient {
    static var primary: Gradient {
        Gradient(
            colors: [
                DesignSystem.Color.primary(),
                DesignSystem.Color.primary().opacity(0.6)
            ]
        )
    }

    static var google: Gradient {
        Gradient(
            colors: [
                Color(hex: 0xEA4335),
                Color(hex: 0xFBBC05),
                Color(hex: 0x4A853),
                Color(hex: 0x285F4)
            ]
        )
    }

    static var divider: Gradient {
        Gradient(
            colors: [
                Color(hex: 0x509058),
                Color(hex: 0xF2FCF0)
            ]
        )
    }
}
