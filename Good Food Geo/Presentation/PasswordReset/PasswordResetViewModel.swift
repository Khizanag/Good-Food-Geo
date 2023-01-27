//
//  PasswordResetViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine

final class PasswordResetViewModel: DefaultViewModel {
    private let repository: MainRepository = DefaultMainRepository()

    enum Event {
        case cleanUpEmailField
        case showMessage(String)
    }

    var eventPublisher = PassthroughSubject<Event, Never>()

    @MainActor
    func resetPassword(for email: String) {
        Task {
            let result = await repository.resetPassword(email: email)

            switch result {
            case .success(let entity):
                eventPublisher.send(.showMessage(entity.message))
                eventPublisher.send(.cleanUpEmailField)
            case .failure(let error):
                showError(error)
            }
        }
    }
}
