//
//  Good_Food_GeoApp.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI
import FBSDKCoreKit

@main
struct Good_Food_GeoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LaunchScreen(viewModel: LaunchScreenViewModel())
                    .onAppear {
                        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                    }
                    .onOpenURL { url in
                        ApplicationDelegate.shared.application(
                            UIApplication.shared,
                            open: url,
                            sourceApplication: nil,
                            annotation: UIApplication.OpenURLOptionsKey.annotation
                        )
                    }
            }
        }
    }
}
