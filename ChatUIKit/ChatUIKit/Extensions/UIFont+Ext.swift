//
//  UIFont+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/17/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit

extension UIFont {
    static func registerFontWithFilename(name: String) {
        //TODO: Do something on guards
        guard let fontsBundleURL = ChatUIKit.bundle().url(forResource: "Fonts", withExtension: "bundle"),
            let fontsBundle = Bundle(url: fontsBundleURL),
            let fontURL = fontsBundle.url(forResource: name, withExtension: "otf"),
            let fontData = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontData) else  { return }
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        } }
    
    class func chatUIKit(name:String, size: CGFloat) -> UIFont? {
        guard let font =  UIFont(name: "GothamNarrow-Bold", size: size) else {
            self.registerFontWithFilename(name:name)
            return UIFont(name: "GothamNarrow-Bold", size: size) }
        return font }
}
