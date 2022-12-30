//
//  Expert.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import Foundation

struct Expert {
    let fullName: String
    let about: String
    let serviceInfo: String
    let phoneNumber: String

    static let example = Expert(
        fullName: "Full Name",  // TODO: Localize
        about: "About him/her",  // TODO: Localize
        serviceInfo: "ინფორმაცია სერვისზე", // TODO: Localize
        phoneNumber: "+995123456789"
    )
}
