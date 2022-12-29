//
//  LinearGradient+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

extension LinearGradient {
    static var background: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color(hex: 0x4F9943),
                    Color(hex: 0x4F9943).opacity(0.5)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
