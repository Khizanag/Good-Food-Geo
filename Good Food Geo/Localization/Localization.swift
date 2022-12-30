//
//  Localization.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import Foundation

enum Localization: String {
    // MARK: - Shared
    case fullName
    case email
    case password
    case confirmPassword
    case idNumber
    case phoneNumber
    case comment
    case location
    case facebook
    case google
    case hi
    case or
    case send
    case gotIt

    // MARK: - Login
    case login
    case loginTitle
    case loginSubtitle
    case loginWithSocialNetworksTitle
    case areYouNotRegistered
    case forgotButtonTitle
    case loginInputIsEmptyErrorMessage

    // MARK: - Registration
    case signUp
    case signUpTitle
    case signUpSubtitle
    case register
    case resend
    case codePlaceholder
    case getVerificationCode
    case verificationCodeInstruction
    case agreeNotifications
    case signUpSmsCodeInfo

    // MARK: - Password Reset
    case passwordResetTitle
    case enterEmailAddress
    case passwordResetEmailPlaceholder
    case passwordResetBackTo
    case passwordResetNoAccount

    // MARK: - Home
    case home

    // MARK: - About Us
    case aboutUs
    case aboutUsDescription
    case aboutUsSectionTitle
    case aboutUsSectionDescription
    case contactUs
    case facebookUrlIsInvalid

    // MARK: - Scanning
    case scanning
    case preScanFormTitle
    case acceptTerms
    case scanProduct

    // MARK: - Donation
    case donation
    case aboutDonationSectionTitle
    case aboutDonationSectionDescription
    case donationBankAccountNumber

    // MARK: - Expert
    case expert
    case expertAboutServiceSectionTitle
    case callExpertSectionTitle
}

extension Localization {
    private var key: String { rawValue }

    private var localized: String {
        let language: Language = (UserDefaults.standard.object(forKey: "language") as? Language) ?? .georgian
        let path = Bundle.main.path(forResource: language.localizableIdentifier, ofType: "lproj")
        let bundle = Bundle(path: path!)!

        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: "", comment: "")
    }

    func callAsFunction() -> String { localized }
}
