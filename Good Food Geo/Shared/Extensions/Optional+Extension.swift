//
//  Optional+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 09.01.23.
//

import Foundation

extension Optional {
    var isNil: Bool {
        self == nil
    }

    var isNotNil: Bool {
        !isNil
    }
}
