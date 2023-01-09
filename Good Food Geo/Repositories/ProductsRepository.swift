//
//  ProductsRepository.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import Foundation
import UIKit

protocol ProductsRepository {
    func submitProductComplaint(_ productComplaint: ProductComplaint) async -> Result<ProductComplaintSubmissionEntity, AppError>
}

struct DefaultProductsRepository: ProductsRepository {
    private let networkLayer: NetworkLayer = DefaultNetworkLayer()

    func submitProductComplaint(_ productComplaint: ProductComplaint) async -> Result<ProductComplaintSubmissionEntity, AppError> {
        let url = EndPoint.products.fullUrl
        var request = URLRequest(url: url)
        request.setMethod(.post)

        let parameters = [
            "picture_name": productComplaint.product.title,
            "full_name": productComplaint.author.fullName,
            "id_number": productComplaint.author.idNumber,
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

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct RequestMedia {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String

    init?(image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }

        self.key = key
        self.filename = "imagefile.jpg"
        self.data = data
        self.mimeType = "image/jpeg"
    }
}
