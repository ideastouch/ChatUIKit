//
//  UIImage+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/21/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit

extension UIImage : BundleTypeConstructor, BundleChatUIKit {
    static func chatUIKit(named:String) -> UIImage? { return ChatUIKitInit(named:named) }
}

