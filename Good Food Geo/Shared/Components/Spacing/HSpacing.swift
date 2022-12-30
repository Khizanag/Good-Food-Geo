//
//  HSpacing.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import SwiftUI

struct HSpacing: View {
    let spacing: Double

    init(_ spacing: Double) {
        self.spacing = spacing
    }

    var body: some View {
        HStack { }
            .padding(.trailing, spacing)
    }
}

struct HSpacing_Previews: PreviewProvider {
    static var previews: some View {
        HSpacing(5)
    }
}
