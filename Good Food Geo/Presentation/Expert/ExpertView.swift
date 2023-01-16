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

    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared
    private let headerViewModel = HeaderViewModel()

    var body: some View {
        StaticPage(
            section: .init(title: "კონსულტაცია", description: "სურსათის უვნებლობის ექსპერტის დახმარების სერვისი"),
            subSections: [
                .init(
                    title: Localization.expertAboutServiceSectionTitle(),
                    content: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("საქართველოს ტრენინგებისა და განვითარების ინსტიტუტი (TDIG)  გთავაზობთ ეტიკეტირების სფეროში ექსპერტის საკონსულტაციო მომსახურეობის სერვისს.")

                            Text("დეტალური ინფორმაციისთვის, დაუკავშირდით ექსპერტს:")
                        }
                        .foregroundColor(.gray)
                        .toAnyView()
                    }
                ),
                .init(
                    title: "მისწერე ექსპერტს",
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
