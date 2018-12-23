//
//  Bundle+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/21/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit

protocol BundleTypeConstructor {
    init?(named name: String, in bundle: Bundle?, compatibleWith traitCollection: UITraitCollection?)
}

protocol BundleChatUIKit {
    associatedtype BundleType: BundleTypeConstructor
    static func chatUIKit(named:String) -> BundleType?
}

func ChatUIKitInit<T:BundleTypeConstructor>(named:String) -> T? {
    let bundle = ChatUIKit.bundle()
    guard let bundleTypeObject = T(named: named, in: bundle, compatibleWith: nil) else {
        assertionFailure("Object named \(named) wasn't find in ChatUIKit,bundle()")
        return nil
    }
    return bundleTypeObject
}



