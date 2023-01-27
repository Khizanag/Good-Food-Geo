//
//  VSpacing.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

struct VSpacing: View {
    let spacing: Double

    init(_ spacing: Double) {
        self.spacing = spacing
    }

    var body: some View {
        VStack { }
            .padding(.bottom, spacing)
    }
}

// MARK: - Previews
struct VSpacing_Previews: PreviewProvider {
    static var previews: some View {
        VSpacing(1)
    }
}
