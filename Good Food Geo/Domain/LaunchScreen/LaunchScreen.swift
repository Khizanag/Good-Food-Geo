//
//  LaunchScreen.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var shouldNavigateToApp = false {
        didSet {
            print("changed to \(shouldNavigateToApp)")
        }
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [DesignSystem.Color.primaryGradientDark(), DesignSystem.Color.primaryGradientLight()]),
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
            .ignoresSafeArea()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
