//
//  PasswordResetViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.01.23.
//

import Combine
import Foundation

final class PasswordResetViewModel: BaseViewModel {
    // MARK: - Properties
    @Published var shouldDismiss = false

    private let repository: MainRepository = DefaultMainRepository()

    enum Event {
        case cleanUpEmailField
        case showMessage(String)
        case dismiss
    }

    var eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Public
    func viewDidAppear() {
        let isLoggedIn = UserDefaults.standard.value(forKey: AppStorageKey.authenticationToken()) != nil
        if isLoggedIn {
            eventPublisher.send(.dismiss)
        }
    }

    @MainActor func resetPassword(for email: String) {
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
