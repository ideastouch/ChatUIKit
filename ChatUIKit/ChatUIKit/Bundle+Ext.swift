//
//  Bundle+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/21/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation

class ChatUIKit {
    class func bundle() -> Bundle {
        return Bundle(for: ChatUIKit.self)
    }
}

public protocol BundleTypeConstructor {
    init?(named name: String, in bundle: Bundle?, compatibleWith traitCollection: UITraitCollection?)
}

public protocol BundleChatUIKit {
    associatedtype BundleType: BundleTypeConstructor
    static func chatUIKit(named:String) -> BundleType?
}

public extension BundleChatUIKit {
    static public func chatUIKit(named:String) -> BundleType? {
        // TODO: Add assert on guards
        let bundle = ChatUIKit.bundle()
        guard let bundleTypeObject = BundleType(named: named, in: bundle, compatibleWith: nil) else { return nil }
        return bundleTypeObject
    }
}
