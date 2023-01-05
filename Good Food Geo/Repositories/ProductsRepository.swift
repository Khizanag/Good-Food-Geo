//
//  ProductsRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation

protocol ProductsRepository {
    func submitProductComplaint(_ productComplaint: ProductComplaint) async -> Result<ProductComplaintSubmissionEntity, AppError>
}

struct DefaultProductsRepository: ProductsRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func submitProductComplaint(_ productComplaint: ProductComplaint) async -> Result<ProductComplaintSubmissionEntity, AppError> {
        .failure(.general)
//        networkLayer.execute(ProductComplaint., using: request)
    }
}
