//
//  Language.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

enum Language: String, CaseIterable {
    case english
    case georgian
}

extension Language {
    static var `default`: Language { .english }
    
    var localizableIdentifier: String {
        switch self {
        case .english:  return "en"
        case .georgian: return "ka"
        }
    }

    var name: String {
        switch self {
        case .english:
            return "English"
        case .georgian:
            return "ქართული"
        }
    }

    var image: Image { Image(rawValue) }

    var icon: String {
        switch self {
        case .english: return "🇬🇧"
        case .georgian: return "🇬🇪"
        }
    }
}
