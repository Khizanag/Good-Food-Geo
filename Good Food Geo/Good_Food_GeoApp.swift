//
//  Good_Food_GeoApp.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

@main
struct Good_Food_GeoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                ContentView()
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                TestTabBarView()
//                LaunchScreen(viewModel: LaunchScreenViewModel())
            }
        }
    }
}
