//
//  ImaggaColor.swift
//  PaletteiOS29
//
//  Created by Darin Armstrong on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import Foundation

struct ImaggaColorResponse: Decodable {
    let result: ColorDictionaries
}

struct ColorDictionaries: Decodable {
    let colors: ColorResults
}

struct ColorResults: Decodable {
    let imaggaColors: [ImaggaColor]
    
    enum CodingKeys: String, CodingKey {
        case imaggaColors = "image_colors"
    }
}

struct ImaggaColor: Decodable {
    let red: Int
    let green: Int
    let blue: Int
    
    enum CodingKeys: String, CodingKey {
        case red = "r"
        case green = "g"
        case blue = "b"
    }
}
