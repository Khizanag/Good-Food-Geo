//
//  ExpertView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ExpertView: View {
    let expert: Expert

    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared

    var body: some View {
        ZStack {
            LinearGradient.background
                .edgesIgnoringSafeArea([.top])

            VStack {
                VStack {
                    HeaderView(fullName: userInformationStorage.read()?.fullName)

                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: 0xE9E9E9))
                                .frame(width: 72, height: 72)

                            DesignSystem.Image.person()
                                .resizable()
                                .foregroundColor(.secondary)
                                .frame(width: 32, height: 32)
                        }

                        VStack(alignment: .leading) {
                            Text(expert.fullName)
                                .foregroundColor(.white)

                            Text(expert.about)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal, 32)

                ZStack {
                    Color.white
                        .cornerRadius(44, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()

                    VStack {
                        SubSectionView(model: .init(title: Localization.expertAboutServiceSectionTitle(), content: {
                            Text(expert.serviceInfo)
                                .foregroundColor(.secondary)
                        }))

                        Spacer()

                        HStack {
                            SubSectionView(model: .init(title: Localization.callExpertSectionTitle(), content: { }))

                            if let url = URL(string: "tel://\(expert.phoneNumber)") {
                                Spacer()

                                Button(action: {
                                    UIApplication.shared.open(url)
                                }, label: {
                                    DesignSystem.Image.phone()
                                })
                                .foregroundColor(.white)
                                .frame(width: 100, height: 44)
                                .background(
                                    LinearGradient(gradient: .primary, startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(22, corners: [.topLeft, .bottomLeft])
                                .offset(x: 36)
                            }
                        }

                        Spacer()
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}

struct ExpertView_Previews: PreviewProvider {
    static var previews: some View {
        ExpertView(expert: .example)
    }
}
