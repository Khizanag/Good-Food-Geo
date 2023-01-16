//
//  SocialNetworkAuthenticationResponse.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 17.01.23.
//

import Foundation

struct SocialNetworkAuthenticationResponse: Decodable {
    // If authentication is succeeded
    let token: String?

    // If authentication is failed, registration is needed
    let userId: String?
    let email: String?
    let name: String?
}
