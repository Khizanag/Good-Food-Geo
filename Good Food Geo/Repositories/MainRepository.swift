//
//  AuthenticationRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 31.12.22.
//

import Foundation

protocol MainRepository {
    func login(email: String, password: String) async -> Result<LoginResponse, AppError>

    func register(with params: RegistrationParams) async -> Result<RegistrationResponse, AppError>

    func registerWithApple(with params: RegistrationParams) async -> Result<RegistrationResponse, AppError>

    func verifyRegistration(email: String, code: String) async -> Result<VerificationEntity, AppError>

    func resetPassword(email: String) async -> Result<PasswordResetEntity, AppError>

    func getUserInformation() async -> Result<UserInformationEntity, AppError>

    func deleteAccount() async -> Result<UserDeletionEntity, AppError>
}

struct DefaultMainRepository: MainRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()
    private let authenticationTokenStorage: AuthenticationTokenStorage = DefaultAuthenticationTokenStorage.shared

    func login(email: String, password: String) async -> Result<LoginResponse, AppError> {
        var request = URLRequest(url: EndPoint.login.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email,
            "password": password
        ])

        return await networkLayer.execute(LoginResponse.self, using: request)
    }

    func register(with params: RegistrationParams) async -> Result<RegistrationResponse, AppError> {
        var request = URLRequest(url: EndPoint.registration.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": params.email,
            "password": params.password,
            "name": params.fullName,
            "phone_number": params.phoneNumber
        ])

        return await networkLayer.execute(RegistrationResponse.self, using: request)
    }

    func registerWithApple(with params: RegistrationParams) async -> Result<RegistrationResponse, AppError> {
        guard let appleUserId = params.appleUserId else { return .failure(.general) }

        var request = URLRequest(url: EndPoint.appleAuthentication.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "apple_email": params.email,
            "apple_user_id": appleUserId,
            "apple_full_password": params.password,
            "apple_full_name": params.fullName,
            "apple_phone_number": params.phoneNumber
        ])

        return await networkLayer.execute(RegistrationResponse.self, using: request)
    }

    func verifyRegistration(email: String, code: String) async -> Result<VerificationEntity, AppError> {
        var request = URLRequest(url: EndPoint.verifyRegistration.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email,
            "confirmation_code": code
        ])

        return await networkLayer.execute(VerificationEntity.self, using: request)
    }

    func resetPassword(email: String) async -> Result<PasswordResetEntity, AppError> {
        var request = URLRequest(url: EndPoint.resetLink.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.setBody([
            "email": email
        ])

        return await networkLayer.execute(PasswordResetEntity.self, using: request)
    }

    func getUserInformation() async -> Result<UserInformationEntity, AppError> {
        guard let token = authenticationTokenStorage.read() else {
            return .failure(.sessionNotFound)
        }

        var request = URLRequest(url: EndPoint.userInformation.fullUrl)
        request.setMethod(.get)
        request.setContentType(.applicationJson)
        request.makeAuthorized(forTokenType: .bearer, using: token)

        let result = await networkLayer.execute(UserInformationDTO.self, using: request)

        switch result {
        case .success(let dto):
            return .success(
                UserInformationEntity(email: dto.email, fullName: dto.name, phoneNumber: dto.phoneNumber)
            )
        case .failure(let error):
            return .failure(error)
        }
    }

    func deleteAccount() async -> Result<UserDeletionEntity, AppError> {
        guard let token = authenticationTokenStorage.read() else {
            return .failure(.sessionNotFound)
        }

        var request = URLRequest(url: EndPoint.deleteAccount.fullUrl)
        request.setMethod(.post)
        request.setContentType(.applicationJson)
        request.makeAuthorized(forTokenType: .bearer, using: token)

        return await networkLayer.execute(UserDeletionEntity.self, using: request)
    }
}
