//
//  UnsplashPhoto.swift
//  PaletteiOS29
//
//  Created by Darin Armstrong on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import Foundation

struct PhotoSearchDictionary: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    
    let urls: URLGroup
    let description: String?
}

struct URLGroup: Decodable {
    let small: String
    let regular: String
}
