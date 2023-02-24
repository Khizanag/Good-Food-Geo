//
//  Localization.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

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
    case agree
    case close
    case copy

    // MARK: - Header
    case logout
    case changeLanguage
    case deleteAccount
    case approveAccountDeletionTitle
    case approveAccountDeletionDescription
    case approveAccountDeletionButtonTitle

    // MARK: - Login
    case login
    case loginTitle
    case loginSubtitle
    case loginWithSocialNetworksTitle
    case areYouNotRegistered
    case forgotButtonTitle
    case loginInputIsEmptyErrorMessage

    // MARK: - Registration
    case register
    case registrationTitle
    case registrationSubtitle
    case resend
    case verify
    case codePlaceholder
    case getVerificationCode
    case verificationCodeInstruction
    case agreeRegistrationTermsDescription
    case signUpSmsCodeInfo

    // MARK: - Terms and Conditions
    case termsAndConditionsTitle
    case privacyPolicyTitle
    case privacyPolicyDescription
    case termsAndConditionsSectionsTitle
    case termsAndConditionsFirstSection
    case termsAndConditionsSecondSection

    // MARK: - Password Reset
    case passwordResetTitle
    case enterEmailAddress
    case passwordResetEmailPlaceholder
    case passwordResetBackTo
    case passwordResetNoAccount

    // MARK: - Home
    case home
    case feedTitle

    // MARK: - About Us
    case aboutUs
    case aboutUsDescription
    case aboutUsSectionTitle
    case aboutUsSectionDescription
    case contactUs
    case facebookUrlIsInvalid
    case visitUsOnFacebook

    // MARK: - Scanning
    case productComplaintSubmissionTitle
    case preScanFormTitle
    case acceptTerms
    case scanProduct
    case productTitle
    case scanFirstImageDescription
    case scanSecondImageDescription
    case scanThirdImageDescription
    case scanFourthImageDescription
    case scanFifthImageDescription

    // MARK: - Donation
    case donation
    case aboutDonationSectionTitle
    case aboutDonationSectionDescription
    case donationBankAccountNumber
    case receiver
    case receiverValue
    case purpose
    case purposeValue

    // MARK: - Expert
    case expert
    case expertPageTitle
    case expertPageSubtitle
    case expertAboutServiceSectionTitle
    case callExpertSectionTitle
    case aboutExpertServiceFirstSectionDescription
    case aboutExpertServiceSecondSectionDescription
    case textToExpert

    // MARK: - Errors
    case technicalErrorDescription
    case sessionNotFoundErrorDescription
    case failedRequestErrorDescription
    case shouldFillAllFieldsDescription
    case passwordsMismatchErrorDescription
    case termsAreNotAgreedErrorDescription
    case imageIsMissingErrorDescription
}

extension Localization {
    private var key: String { rawValue }

    private var localized: String {
        let language = DefaultLanguageStorage.shared.read()
        let path = Bundle.main.path(forResource: language.localizableIdentifier, ofType: "lproj")
        let bundle = Bundle(path: path!)!

        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: "", comment: "")
    }

    func callAsFunction() -> String { localized }
}
