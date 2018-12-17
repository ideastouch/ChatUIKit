//
//  UIFont+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/17/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit

public extension UIFont {
    static func registerFontWithFilename(name: String) {
        //TODO: Do something on guards
//        if let frameworkBundle = Bundle(identifier: bundleIdentifierString) {
        guard let path = Bundle.init(identifier: "org.cocoapods.ChatUIKit")?.path(forResource: name, ofType: "otf") else { return }
        guard let fontData = NSData(contentsOfFile: path) else { return }
        guard let dataProvider = CGDataProvider(data: fontData) else { return }
        guard let fontRef = CGFont(dataProvider) else { return }
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
    
    class func chatUIKit(name:String, size: CGFloat) -> UIFont? {
        guard let color =  UIFont(name: "GothamNarrow-Bold", size: size) else {
            self.registerFontWithFilename(name:name)
            return UIFont(name: "GothamNarrow-Bold", size: size)
        }
        return color
    }
}
