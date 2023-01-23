//
//  URLCache+Extension.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.01.23.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
