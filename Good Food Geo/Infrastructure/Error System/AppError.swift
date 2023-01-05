//
//  AppError.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

enum AppError: Error {
    case general
    case descriptive(String)
    case parsing
    case sessionNotFound
    case wrongStatusCode
}

extension AppError {
    var description: String {
        switch self {
        case .general:
            return "An error has happened"
        case .descriptive(let description):
            return description
        case .parsing:
            return "Parsing error has happened"
        case .sessionNotFound:
            return "You are not logged in. Session is invalid."
        case .wrongStatusCode:
            return "Technical error during service call"
        }
    }
}
