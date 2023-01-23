//
//  TestTabBarView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

// MARK: - HomeTabBarConstant
struct MainTabBarConstant {
    static private var hasBottomSwipeIndicator : Bool {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0 > 20
    }

    static var height : CGFloat{
        54 + (hasBottomSwipeIndicator ? 20 : 0)
    }
}

// MARK: - HomeTabBarItem
enum MainTabBarItem {
    case home
    case aboutUs
    case scanning
    case donation
    case expert
}

// MARK: - MainTabBarView
struct MainTabBarView: View {
    @State private var selectedTabBarItem: MainTabBarItem = .home

    private struct MainTabBarItemModel {
        let type: MainTabBarItem
        let title: String
        let icon: Image
    }

    private let tabBarItems: [MainTabBarItemModel] = [
        .init(type: .home, title: Localization.home(), icon: DesignSystem.Image.house()),
        .init(type: .aboutUs, title: Localization.aboutUs(), icon: DesignSystem.Image.book()),
        .init(type: .donation, title: Localization.donation(), icon: DesignSystem.Image.creditCard()),
        .init(type: .expert, title: Localization.expert(), icon: DesignSystem.Image.person())
    ]

    // MARK: - Body
    var body: some View {
        ZStack {
            TabView(selection: $selectedTabBarItem) {
                HomeView(viewModel: HomeViewModel())
                    .tag(MainTabBarItem.home)

                AboutUsView()
                    .tag(MainTabBarItem.aboutUs)

                ProductComplaintSubmissionView(viewModel: ProductComplaintSubmissionViewModel())
                    .tag(MainTabBarItem.scanning)

                DonationView()
                    .tag(MainTabBarItem.donation)

                ExpertView(expert: .example)
                    .tag(MainTabBarItem.expert)
            }
            .background(Color.clear)

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
                .frame(height: MainTabBarConstant.height)
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }

    private func makeTabBarItem(with model: MainTabBarItemModel) -> some View {
        let color: Color = selectedTabBarItem == model.type ? .black : .white

        return HStack {
            Button(action: {
                selectedTabBarItem = model.type
            }, label: {
                VStack(spacing: 4) {
                    model.icon
                        .foregroundColor(color)

                    Text(model.title)
                        .font(.caption)
                        .foregroundColor(color)
                }
                .padding(2)
            })
        }
    }
}

// MARK: - Previews
struct TestTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
