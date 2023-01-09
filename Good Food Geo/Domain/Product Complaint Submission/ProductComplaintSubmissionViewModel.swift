//
//  ProductComplaintSubmissionViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

final class ProductComplaintSubmissionViewModel: DefaultViewModel {
    private let productsRepository: ProductsRepository = DefaultProductsRepository()

    private let numRequiredImages = 3

    func submitProductComplaint(_ productComplaint: ProductComplaint) {
        let allInputIsFilled = [
            productComplaint.location,
            productComplaint.comment,
            productComplaint.product.title,
            productComplaint.author.fullName,
            productComplaint.author.idNumber,
        ]
            .allSatisfy({ !$0.isEmpty })

        guard allInputIsFilled else {
            showError(.descriptive("All fields should be filled to submit the information"))
            return
        }

        guard productComplaint.areTermsAgreed else {
            showError(.descriptive("You should accept our terms of Use and Privacy Statement to submit the information"))
            return
        }

        guard productComplaint.product.images.count == numRequiredImages else {
            showError(.descriptive("Please select image all images to submit the information"))
            return
        }

        Task {
            let result = await productsRepository.submitProductComplaint(productComplaint)

            switch result {
            case .success(let entity):
                print("submitProductComplaint did finish: entity: \(entity)")
            case .failure(let error):
                showError(error)
            }
        }
    }
}
