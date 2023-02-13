//
//  LogoutUseCase.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import SwiftUI

protocol LogoutUseCase {
    func execute()
}

struct DefaultLogoutUseCase: LogoutUseCase {
    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?
    
    func execute() {
        authenticationToken = nil
    }
}
