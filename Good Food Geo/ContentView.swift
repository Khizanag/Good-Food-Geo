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

    @State private var selection: TabItem = .aboutUs

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    DesignSystem.Image.house()
                    Text(Localization.home())
                }
                .tag(TabItem.home)

            AboutUsView()
                .tabItem {
                    DesignSystem.Image.book()
                    Text(Localization.aboutUs())
                }
                .tag(TabItem.aboutUs)

            ScanView()
                .tabItem {
                    DesignSystem.Image.qr()
                }
                .tag(TabItem.scanning)

            DonationView()
                .tabItem {
                    DesignSystem.Image.creditCard()
                    Text(Localization.donation())
                }
                .tag(TabItem.donation)

            ExpertView()
                .tabItem {
                    DesignSystem.Image.person()
                    Text(Localization.expert())
                }
                .tag(TabItem.expert)
        }
    }

}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

enum TabItem {
    case home
    case aboutUs
    case scanning
    case donation
    case expert
}
