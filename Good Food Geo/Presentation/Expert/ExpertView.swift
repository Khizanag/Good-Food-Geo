//
//  ExpertView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ExpertView: View {
    @Environment(\.dismiss) private var dismiss

    let expert: Expert
    
    var body: some View {
        PrimaryPageView(
            section: .init(title: Localization.expertPageTitle(), description: Localization.expertPageSubtitle()),
            subSections: [
                .init(
                    title: Localization.expertAboutServiceSectionTitle(),
                    content: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(Localization.aboutExpertServiceFirstSectionDescription())
                            Text(Localization.aboutExpertServiceSecondSectionDescription())
                        }
                        .foregroundColor(.gray)
                        .toAnyView()
                    }
                ),
                .init(
                    title: Localization.textToExpert(),
                    content: {
                        Text("\(Localization.email()): GFGAPK@GMAIL.COM")
                            .toAnyView()
                    }
                )
            ]
        )
    }
}

struct ExpertView_Previews: PreviewProvider {
    static var previews: some View {
        ExpertView(expert: .example)
    }
}
