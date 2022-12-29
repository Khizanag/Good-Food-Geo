//
//  HorizontalDivider.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct HorizontalDivider: View {
    let color: Color
    let height: CGFloat

    init(color: Color, height: CGFloat = 1) {
        self.color = color
        self.height = height
    }

    var body: some View {
        color
            .frame(height: height)
    }
}

struct HorizontalDivider_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalDivider(color: DesignSystem.Color.primary())
    }
}
