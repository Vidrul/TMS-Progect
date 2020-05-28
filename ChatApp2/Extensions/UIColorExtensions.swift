//
//  UIColorExtensions.swift
//  ChatApp2
//
//  Created by David Saley on 5/11/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

//MARK: - Extensions UIColor
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
