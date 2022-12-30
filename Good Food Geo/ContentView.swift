//
//  ContentView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var selection: HomeTabBarItem = .aboutUs

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    DesignSystem.Image.house()
                    Text(Localization.home())
                }
                .tag(HomeTabBarItem.home)

            AboutUsView()
                .tabItem {
                    DesignSystem.Image.book()
                    Text(Localization.aboutUs())
                }
                .tag(HomeTabBarItem.aboutUs)

            ScanView()
                .tabItem {
                    DesignSystem.Image.qr()
                }
                .tag(HomeTabBarItem.scanning)

            DonationView()
                .tabItem {
                    DesignSystem.Image.creditCard()
                    Text(Localization.donation())
                }
                .tag(HomeTabBarItem.donation)

            ExpertView(expert: .example)
                .tabItem {
                    DesignSystem.Image.person()
                    Text(Localization.expert())
                }
                .tag(HomeTabBarItem.expert)
        }
    }

}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

enum HomeTabBarItem {
    case home
    case aboutUs
    case scanning
    case donation
    case expert
}
