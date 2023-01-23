//
//  Arrangable.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.01.23.
//

import Foundation

protocol Arrangable {
    var arranged: [Self] { get }
}

extension Arrangable where Self: Equatable {
    var next: Self? {
        guard let currentIndex = arranged.firstIndex(of: self) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < arranged.count else { return nil }
        return arranged[nextIndex]
    }
}
