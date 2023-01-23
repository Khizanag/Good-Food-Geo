//
//  RegistrationTermsAndConditionsView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.01.23.
//

import SwiftUI

struct RegistrationTermsAndConditionsView: View {
    @Binding var userAgreesTerms: Bool
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {


            VStack(alignment: .leading, spacing: 32) {
                Text("აპლიკაციის გამოყენების პირობები")
                    .font(.title)
                    .bold()

                VStack(alignment: .leading, spacing: 8) {
                    Text("პირადი მონაცემების პოლიტიკა")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .italic()

                    Text("აპლიკაციის მუშაობს კონფიდენციალურობის პოლიტიკის სამართლებრივი საფუძვლის გათვალისწინებით, რომლის ფარგლებში პირად მონაცემთა უსაფრთხოება დაცულია.")
                        .font(.body)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("ვეთანხმები წესებს და პირობებს")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .italic()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("მომხმარებელი გამოგზავნამდე ადასტურებს თანხმობას, რომ სრულად პასუხისმგებელია ინფორმაციის უტყუარობასა და შინაარსზე და ინფორმირებულია, რომ მის მიერ მოწოდებული ინფორმაციის საფუძველზე მოხდება მიმართვა ბიზნესსუბიექტებისა და სურსათის ეროვნული სააგენტოსათვის.")
                            .font(.body)
                        Text("დახარვეზდება ისეთი მოწოდებული მასალები, რაც შეიცავს აშკარა ბუნდოვანებას და გაურკევლობას და ასეთ შემთხვევაში დაზუსტების მიზნით, კომუნიკაცია იწარმოებს მომხმარებელთან.")
                            .font(.body)
                    }
                }

                VStack {
                    PrimaryButton(
                        action: {
                            userAgreesTerms = true
                            isPresented = false
                        },
                        label: { Text("ვეთანხმები") },
                        backgroundColor: .green.opacity(0.85)
                    )

                    PrimaryButton(
                        action: {
                            isPresented = false
                        },
                        label: { Text("დახურვა") },
                        backgroundColor: .red.opacity(0.85)
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Previews
struct RegistrationTermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationTermsAndConditionsView(userAgreesTerms: .constant(true), isPresented: .constant(false))
    }
}
