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
            return "ტექნიკური შეცდომა"
        case .descriptive(let description):
            return description
        case .parsing:
            return "ტექნიკური შეცდომა"
        case .sessionNotFound:
            return "მიმდინარე სესია არაა აქტიური. გთხოვთ გამოხვიდეთ პროფილიდან და თავიდან გაიაროთ ავტორიზაცია"
        case .wrongStatusCode:
            return "მოთხოვნა შესრულდა წარუმატებლად"
        }
    }
}
