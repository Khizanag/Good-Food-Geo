//
//  String+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 09.01.23.
//

import Foundation

extension String {
    func uppercasedFirstLetter() -> String {
        prefix(1).uppercased() + dropFirst()
    }
}
