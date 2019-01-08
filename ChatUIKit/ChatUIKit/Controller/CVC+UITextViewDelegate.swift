//
//  CVC+UITextViewDelegate.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/23/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.resetTablePosition() }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.resetTablePosition() }
    
    public func textViewDidChange(_ textView: UITextView) {
        struct HeightSizes {
            static let min:CGFloat = 44
            static let font = UIFont.systemFont(ofSize: 15.0)
            static let row = font.lineHeight
            static let max = 5 * row
            static let delta = min - row
            static let attributes = [NSAttributedString.Key.font:font]
            static func height(_ textHeight:CGFloat) -> CGFloat {
                if textHeight > max { return  max + delta }
                let rows = textHeight / row
                if rows > 1 {
                    return textHeight + delta }
                return min } }
        self.sendButton.isEnabled = textView.text.count > 0
        let attributeString = NSAttributedString(
            string:textView.text,
            attributes:HeightSizes.attributes)
        let size = attributeString.boundingRect(
            with: CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            context: nil)
        let constant = HeightSizes.height(size.height)
        if self.toolbarHeightLayoutConstraint.constant != constant {
            self.toolbarHeightLayoutConstraint.constant = constant
            self.view.layoutIfNeeded() }
        self.resetTablePosition() }

}
