//
//  TestTabBarView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

struct HomeTabBarConstant {
    static private var hasBottomSwipeIndicator : Bool {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0 > 20
    }

    static var height : CGFloat{
        54 + (hasBottomSwipeIndicator ? 20 : 0)
    }
}

struct TestTabBarView: View {
    @State private var selectedTabBarItem: HomeTabBarItem = .home

    private struct HomeTabBarItemModel {
        let type: HomeTabBarItem
        let title: String
        let icon: Image
    }

    private let tabBarItems: [HomeTabBarItemModel] = [
        .init(type: .home, title: Localization.home(), icon: DesignSystem.Image.house()),
        .init(type: .aboutUs, title: Localization.aboutUs(), icon: DesignSystem.Image.book()),
        .init(type: .donation, title: Localization.donation(), icon: DesignSystem.Image.creditCard()),
        .init(type: .expert, title: Localization.expert(), icon: DesignSystem.Image.person())
    ]

    // MARK: - Body
    var body: some View {
        ZStack {
            switch selectedTabBarItem {
            case .home:
                HomeView()
            case .aboutUs:
                AboutUsView()
            case .scanning:
                ScanView()
            case .donation:
                DonationView()
            case .expert:
                ExpertView(expert: .example)
            }

            VStack {
                Spacer()

                ZStack {
                    TabBarBackgroundView()

                    TabBarMainItemView(icon: DesignSystem.Image.qr()) {
                        selectedTabBarItem = .scanning
                    }

                    HStack {
                        makeTabBarItem(with: tabBarItems[0])
                        makeTabBarItem(with: tabBarItems[1])
                        Spacer()
                        makeTabBarItem(with: tabBarItems[2])
                        makeTabBarItem(with: tabBarItems[3])
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .frame(height: HomeTabBarConstant.height)
            }
        }
        .edgesIgnoringSafeArea([.bottom])
    }

    private func makeTabBarItem(with model: HomeTabBarItemModel) -> some View {
        let activeColor: Color = .black
        let inactiveColor: Color = .white

        return HStack {
            Button(action: {
                selectedTabBarItem = model.type
            }, label: {
                VStack(spacing: 4) {
                    model.icon
                        .foregroundColor(selectedTabBarItem == model.type ? activeColor : inactiveColor)

                    Text(model.title)
                        .font(.caption)
                        .foregroundColor(selectedTabBarItem == model.type ? activeColor : inactiveColor)
                }
                .padding(2)
            })
        }
    }
}

struct TestTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TestTabBarView()
    }
}
