//
//  UIColorExtension.swift
//  PaletteiOS29
//
//  Created by Darin Armstrong on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    convenience init(_ imaggaColor: ImaggaColor){
        let red = CGFloat(imaggaColor.red) / 255
        let green = CGFloat(imaggaColor.green) / 255
        let blue = CGFloat(imaggaColor.blue) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
