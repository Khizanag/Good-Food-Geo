//
//  TabBarBackgroundView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

struct TabBarBackgroundView : View {
    var body: some View {
        TabBarShape()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: 0x4F9943), Color(hex: 0x9BD192)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: HomeTabBarConstant.height)
    }
}
