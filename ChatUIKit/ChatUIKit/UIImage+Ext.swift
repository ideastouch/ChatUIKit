//
//  UIImage+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/17/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static public func chatUIKit(named:String, type:String = "png") -> UIImage? {
        // TODO: Add assert on guards
//        guard let customBundle = Bundle.init(identifier: "org.cocoapods.ChatUIKit")?.path(forResource: "ChatUIKit", ofType: "bundle") else {
//            return nil }
//        let imagePath = customBundle.appending("/\(named).\(type)")
        guard let imagePath = Bundle.init(identifier: "org.cocoapods.ChatUIKit")?.path(forResource: named, ofType: type) else { return nil }
        guard let image = UIImage(contentsOfFile:imagePath) else { return nil }
        return image
    }
}