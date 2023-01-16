//
//  LaunchScreenViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 30.12.22.
//

import Foundation
import Combine

final class LaunchScreenViewModel: ObservableObject {
    @Published var shouldDismissAndNavigate = false

    private var subscriptions = Set<AnyCancellable>()

    func viewDidAppear() {
        let timer = Timer
            .publish(every: 1, on: .main, in: .common) // TODO: change to 3
            .autoconnect()

        timer
            .sink { [weak self] _ in
                guard let self else { return }
                self.shouldDismissAndNavigate = true
                timer.upstream.connect().cancel()
            }
            .store(in: &subscriptions)
    }
}
