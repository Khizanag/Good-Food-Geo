//
//  Product.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import UIKit

struct ProductComplaint {
    struct Product {
        let title: String
        let images: [UIImage]
    }

    struct Author {
        let fullName: String
    }

    let product: Product
    let author: Author
    let comment: String
    let location: String
    let areTermsAgreed: Bool
}
