//
//  TabBarMainItemView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

struct TabBarMainItemView : View {
    let icon: Image
    let action: () -> Void

    var body: some View{
        Button(action: action, label: {
            icon
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding()
        })
        .frame(width: 55, height: 55)
        .background(Color(hex: 0xE10000))
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
        .position(x: UIScreen.main.bounds.width/2, y: 12)
    }
}
