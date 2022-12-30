//
//  TabBarShape.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let middleX = rect.width / 2.0
        let curveMissingLength: Double = rect.width * 35.0 / 100.0
        let curveDepth: Double = 47
        let topRemainedLength: CGFloat = (rect.width - curveMissingLength) / 2
        let dXForCurve: Double = 36
        let dYForCurve: Double = 2

        var path = Path()
        path.move(to: .zero)
        path.addLine(to: .init(x: 0, y: rect.height))
        path.addLine(to: .init(x: rect.width, y: rect.height))
        path.addLine(to: .init(x: rect.width, y: 0))
        path.addLine(to: .init(x: rect.width - topRemainedLength, y: 0))
        path.addCurve(
            to: CGPoint(x: middleX, y: curveDepth),
            control1: CGPoint(x: rect.width - topRemainedLength - dXForCurve, y: dYForCurve),
            control2: CGPoint(x: middleX + dXForCurve, y: curveDepth - dYForCurve)
        )
        path.addCurve(
            to: CGPoint(x: topRemainedLength, y: 0),
            control1: CGPoint(x: middleX - dXForCurve, y: curveDepth - dYForCurve),
            control2: CGPoint(x: topRemainedLength + dXForCurve, y: dYForCurve)
        )
        path.addLine(to: .init(x: topRemainedLength, y: 0))
        path.addLine(to: .zero)

        return path
    }
}


// MARK: - Previews
struct TabBarShape_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            TabBarShape()
                .fill(.red)
                .frame(height: 75)
        }
        .ignoresSafeArea()
    }
}
