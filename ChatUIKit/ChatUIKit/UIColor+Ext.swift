//
//  UIColor+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/16/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit

func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let blue = CGFloat(rgbValue & 0xFF)/255.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

extension UIColor {
    class var chatGray: UIColor {
        return UIColorFromHex(0xAAAAAA, alpha: 1)
    }
    class var chatLightGray: UIColor {
        return UIColorFromHex(0xECECEC, alpha: 1)
    }
}
