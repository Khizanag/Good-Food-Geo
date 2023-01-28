//
//  LanguageStorage.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 27.01.23.
//

import SwiftUI

protocol LanguageStorage {
    func read() -> Language
    func write(_ language: Language)
}

struct DefaultLanguageStorage: LanguageStorage {
    
    static var shared = DefaultLanguageStorage()
    
    @AppStorage(AppStorageKey.language()) private var language: Language = .english
    
    private init() { }
    
    func read() -> Language {
        language
    }
    
    func write(_ language: Language) {
        self.language = language
    }
}
