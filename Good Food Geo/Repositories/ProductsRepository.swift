//
//  ProductsRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import UIKit
import SwiftUI

protocol ProductsRepository {
    func submitProductComplaint(_ productComplaint: ProductComplaint) async -> Result<ProductComplaintSubmissionEntity, AppError>
}

struct DefaultProductsRepository: ProductsRepository {
    @AppStorage(AppStorageKey.authenticationToken()) private var authenticationToken: String?

    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func submitProductComplaint(_ productComplaint: ProductComplaint) async -> Result<ProductComplaintSubmissionEntity, AppError> {
        guard let token = authenticationToken else { return .failure(.sessionNotFound) }

        var request = URLRequest(url: EndPoint.products.fullUrl)
        request.setMethod(.post)
        request.makeAuthorized(forTokenType: .bearer, using: token)

        let parameters = [
            "picture_name": productComplaint.product.title,
            "full_name": productComplaint.author.fullName,
            "comment": productComplaint.comment,
            "location": productComplaint.location
        ]

        let mediaImages = productComplaint.product.images.enumerated().compactMap { (index, image) in
            RequestMedia(image: image, forKey: "picture\(index == 0 ? "" : "\(index+1)")")
        }

        let boundary = generateBoundary()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = createDataBody(params: parameters, media: mediaImages, boundary: boundary)

        return await networkLayer.execute(ProductComplaintSubmissionEntity.self, using: request)
    }

    private func createDataBody(params: [String: String], media: [RequestMedia], boundary: String) -> Data {
        let lineBreak = "\r\n"

        var body = Data()

        for (key, value) in params {
            body.append("--\(boundary)" + lineBreak)
            body.append("Content-Disposition: form-data; name=\"\(key)\"" + lineBreak + lineBreak)
            body.append(value + lineBreak)
        }

        for photo in media {
            body.append("--\(boundary)" + lineBreak)
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"" + lineBreak)
            body.append("Content-Type: \(photo.mimeType)" + lineBreak + lineBreak)
            body.append(photo.data)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }

    func generateBoundary() -> String {
        "Boundary-\(UUID().uuidString)"
    }
}

// MARK: - RequestMedia
struct RequestMedia {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String

    init?(image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { return nil }

        self.key = key
        self.filename = UUID().uuidString + ".jpeg"
        self.data = data
        self.mimeType = "image/jpeg"
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
