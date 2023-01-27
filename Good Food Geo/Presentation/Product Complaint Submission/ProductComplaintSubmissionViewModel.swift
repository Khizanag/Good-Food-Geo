//
//  ProductComplaintSubmissionViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation
import Combine

final class ProductComplaintSubmissionViewModel: DefaultViewModel {
    private let productsRepository: ProductsRepository = DefaultProductsRepository()

    let numRequiredImages = 5

    @Published var isLoading = false

    // MARK: - Events
    enum Event {
        case cleanUp
    }

    let eventPublisher = PassthroughSubject<Event, Never>()

    func submitProductComplaint(_ productComplaint: ProductComplaint) {
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

        guard productComplaint.areTermsAgreed else {
            showError(.termsAreNotAgreed)
            return
        }

        guard productComplaint.product.images.count == numRequiredImages else {
            showError(.descriptive("გთხოვთ, ატვირთეთ ყველა მოთხოვნილი ფოტო"))
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
