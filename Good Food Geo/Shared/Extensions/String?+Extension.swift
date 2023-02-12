//
//  String?+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 07.02.23.
//
//
//extension String? {
//    var orEmpty: String {
//        self ?? ""
//    }
//}


extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}
