//
//  MessageDisplayer.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 02.01.23.
//

@MainActor
protocol MessageDisplayer: AnyObject {
    func showMessage(_ message: String, description: String?)

    var alertData: AlertData { get set }
}

extension MessageDisplayer {
    func showMessage(_ message: String, description: String? = nil) {
        alertData.title = message
        if let description {
            alertData.subtitle = description
        }
        alertData.isPresented = true
    }
}
