//
//  Product.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import SwiftUI

struct ProductComplaint {
    struct Product {
        let title: String
        let images: [Image]
    }

    struct Author {
        let fullName: String
        let idNumber: String
    }

    let product: Product
    let author: Author
    let comment: String
    let location: String
}
