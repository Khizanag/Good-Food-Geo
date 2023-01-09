//
//  ProductComplaintSubmissionViewModel.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

final class ProductComplaintSubmissionViewModel: DefaultViewModel {
    private let productsRepository: ProductsRepository = DefaultProductsRepository()

    func submitProductComplaint(_ productComplaint: ProductComplaint) {
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
