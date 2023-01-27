//
//  AppError.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

enum AppError: Error {
    case general
    case descriptive(String)
    case parsing
    case sessionNotFound
    case wrongStatusCode
    case emptyField
    case passwordsMismatch
    case termsAreNotAgreed
}

extension AppError {
    var description: String {
        switch self {
        case .sessionNotFound:
            return Localization.sessionNotFoundErrorDescription()
        case .wrongStatusCode:
            return Localization.failedRequestErrorDescription()
        case .emptyField:
            return Localization.shouldFillAllFieldsDescription()
        case .passwordsMismatch:
            return Localization.passwordsMismatchErrorDescription()
        case .termsAreNotAgreed:
            return Localization.termsAreNotAgreedErrorDescription()
        case .descriptive(let description):
            return description
        case .general, .parsing:
            return Localization.technicalErrorDescription()
        }
    }
}
