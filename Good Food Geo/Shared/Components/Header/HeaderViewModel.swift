//
//  HeaderViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Combine

final class HeaderViewModel: ObservableObject {

    private let logoutUseCase: LogoutUseCase = DefaultLogoutUseCase()

    enum Event {
        case shouldLogout
    }
    var eventPublisher = PassthroughSubject<Event, Never>()

    func logout() {
        logoutUseCase.execute()
        eventPublisher.send(.shouldLogout)
    }
}
