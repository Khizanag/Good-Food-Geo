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
        fullName: "Full Name",
        about: "About him/her",
        serviceInfo: "Information about the service",
        phoneNumber: "+995598935050"
    )
}
