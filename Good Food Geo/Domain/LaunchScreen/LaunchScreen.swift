//
//  LaunchScreen.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct LaunchScreen: View {
    @ObservedObject var viewModel: LaunchScreenViewModel

    var paths: [String] = []

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [DesignSystem.Color.primaryGradientDark(), DesignSystem.Color.primaryGradientLight()]),
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
            .ignoresSafeArea()

            DesignSystem.Image.launchScreenIcon()
                .offset(y: -32)
        }
        .onAppear {
            viewModel.viewDidAppear()
        }

        NavigationLink(destination: LoginView(), isActive: $viewModel.shouldDismissAndNavigate, label: { EmptyView() })
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen(viewModel: LaunchScreenViewModel())
    }
}
