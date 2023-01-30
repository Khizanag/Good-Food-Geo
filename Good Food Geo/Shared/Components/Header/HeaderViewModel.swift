//
//  HeaderViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Combine
import Foundation

final class HeaderViewModel: BaseViewModel {
    private let logoutUseCase: LogoutUseCase = DefaultLogoutUseCase()
    private let languageStorage: LanguageStorage = DefaultLanguageStorage.shared
    private let mainRepository: MainRepository = DefaultMainRepository()

    @Published var isLoading = false
    
    enum Event {
        case shouldLogout
        case showMessage(String)
    }
    var eventPublisher = PassthroughSubject<Event, Never>()
    
    func changeLanguage(to newLanguage: Language) {
        languageStorage.write(newLanguage)
    }

    @MainActor func deleteAccount() {
        isLoading = true

        Task {
            let result = await self.mainRepository.deleteAccount()
            switch result {
            case .success(let entity):
                self.eventPublisher.send(.showMessage(entity.message))
                logout()
            case .failure(let error):
                self.showError(error)
            }

            self.isLoading = false
        }
    }
    
    @MainActor func logout() {
        logoutUseCase.execute()
        eventPublisher.send(.shouldLogout)
    }
}
