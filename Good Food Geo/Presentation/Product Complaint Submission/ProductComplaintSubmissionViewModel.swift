//
//  ProductComplaintSubmissionViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation
import Combine

final class ProductComplaintSubmissionViewModel: BaseViewModel {
    private let productsRepository: ProductsRepository = DefaultProductsRepository()

    private let numRequiredImages = 5

    @Published var isLoading = false

    // MARK: - Events
    enum Event {
        case cleanUp
        case updateLocalizations
    }

    let eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Public Methods
    func viewDidAppear() {
        eventPublisher.send(.updateLocalizations)
    }

    @MainActor func submitProductComplaint(_ productComplaint: ProductComplaint) {
        let allInputIsFilled = [
            productComplaint.location,
            productComplaint.comment,
            productComplaint.product.title,
            productComplaint.author.fullName
        ]
            .allSatisfy({ !$0.isEmpty })

        guard allInputIsFilled else {
            showError(.emptyField)
            return
        }
        guard productComplaint.termsAreAgreed else {
            showError(.termsAreNotAgreed)
            return
        }
        guard productComplaint.product.images.count == numRequiredImages else {
            showError(.imageIsMissing)
            return
        }

        Task {
            isLoading = true
            let result = await productsRepository.submitProductComplaint(productComplaint)
            isLoading = false

            switch result {
            case .success(let entity):
                showError(.descriptive(entity.message))
                eventPublisher.send(.cleanUp)
            case .failure(let error):
                showError(error)
            }
        }
    }
}
