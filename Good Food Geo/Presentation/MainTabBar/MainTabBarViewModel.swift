//
//  MainTabBarViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 31.01.23.
//

final class MainTabBarViewModel: BaseViewModel {
    // MARK: - Properties
    private let mainRepository: MainRepository = DefaultMainRepository()
    private let userInformationStorage: UserInformationStorage = DefaultUserInformationStorage.shared

    private var userInformationIsUpToDate = false

    func updateUserInformationIfNeeded() {
        if !userInformationIsUpToDate {
            userInformationIsUpToDate = true
            Task {
                let result = await mainRepository.getUserInformation()

                Task { @MainActor in
                    switch result {
                    case .success(let entity):
                        userInformationStorage.write(entity)
                    case .failure(let error):
                        showError(error)
                    }
                }
            }
        }

    }
}
