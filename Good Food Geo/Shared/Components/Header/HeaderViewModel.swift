//
//  HeaderViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Combine

final class HeaderViewModel: ObservableObject {
    private let logoutUseCase: LogoutUseCase = DefaultLogoutUseCase()
    private let languageStorage: LanguageStorage = DefaultLanguageStorage.shared

    @Published var isLoading = false
    
    enum Event {
        case shouldLogout
    }
    var eventPublisher = PassthroughSubject<Event, Never>()
    
    func changeLanguage(to newLanguage: Language) {
        languageStorage.write(newLanguage)
    }

    func deleteAccount() {
        isLoading = true
        #warning("Implement account deletion")
        eventPublisher.send(.shouldLogout)
        isLoading = false
    }
    
    func logout() {
        logoutUseCase.execute()
        eventPublisher.send(.shouldLogout)
    }
}
