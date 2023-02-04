//
//  DefaultViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 06.01.23.
//

import Combine
import SwiftUI

class BaseViewModel: ObservableObject {
    @AppStorage(AppStorageKey.language()) private var language: Language = .default

    var errorPublisher = PassthroughSubject<AppError, Never>()
    
    func showError(_ error: AppError) {
        errorPublisher.send(error)
    }
}
