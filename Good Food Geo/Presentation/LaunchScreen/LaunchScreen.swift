//
//  LaunchScreen.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct LaunchScreen: View {
    // MARK: - Properties
    @StateObject var viewModel: LaunchScreenViewModel

    // MARK: - Body
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
        .navigationDestination(isPresented: $viewModel.shouldDismissAndNavigate) {
            LoginView(viewModel: LoginViewModel())
        }
   }
}

// MARK: - Previews
struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen(viewModel: LaunchScreenViewModel())
    }
}
