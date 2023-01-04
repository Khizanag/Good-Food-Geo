//
//  PasswordResetViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine

final class PasswordResetViewModel: ObservableObject {
    private let repository: Repository = DefaultRepository()

    enum Event {
        case cleanUpEmailField
        case showMessage(String)
    }

    var eventPublisher = PassthroughSubject<Event, Never>()

    @MainActor
    func resetPassword(for email: String) {
        Task {
            guard let entity = await repository.resetPassword(email: email) else { return }
            eventPublisher.send(.showMessage(entity.message))
            eventPublisher.send(.cleanUpEmailField)
        }
    }
}
