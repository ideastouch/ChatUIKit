//
//  BubbleData.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/21/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit

class BubbleData {
    struct Position {
        static let None   = 0x00
        static let First  = 0x01
        static let Middle = 0x02
        static let Last   = 0x04 }
    
    enum Sender {
        case none
        case right
        case left
        case other }
    
    enum Name:String {
        case BubbleRight = "BubbleRight"
        case TalkRight   = "TalkRight"
        case BubbleLeft  = "BubbleLeft"
        case TalkLeft    = "TalkLeft"
        case BubbleOther = "BubbleOther"
        case TalkOther   = "TalkOther" }
    
    class func senderGroupToPosition(_ prev:Sender, current:Sender, next:Sender) -> Int {
        switch (prev, next) {
        case (Sender.none, current):
            return Position.First
        case (current, Sender.none):
            return Position.Last
        case (current, current):
            return Position.Middle
        case (current, _):
            return Position.Last
        case (_,current):
            return Position.First
        default:
            return Position.First | Position.Last } }
    
    let description:(position:Int, sender:Sender)
    let text:(header:String?, boddy:String, footerLead:String?, footer:String?)
    let name:String?
    
    init(description:(position:Int, sender:Sender),
         text:(header:String?, boddy:String, footerLead:String?, footer:String?)) {
        // TODO: Add test cases for the switch below
        self.text = text
        self.description = description
        switch (self.description.position, self.description.sender) {
        case let (position, .right) where (position & Position.Last) != Position.Last:
            self.name = Name.BubbleRight.rawValue
        case let (position, .right) where (position & Position.Last) == Position.Last:
            self.name = Name.TalkRight.rawValue
        case let (position, .left) where (position & Position.Last) != Position.Last:
            self.name = Name.BubbleLeft.rawValue
        case let (position, .left) where (position & Position.Last) == Position.Last:
            self.name = Name.TalkLeft.rawValue
        case let (position, .other) where (position & Position.Last) != Position.Last:
            self.name = Name.BubbleOther.rawValue
        case let (position, .other) where (position & Position.Last) == Position.Last:
            self.name = Name.TalkOther.rawValue
        default:
            self.name = nil } }
    
    static var chatFontInfo:UIFont {
        guard let font = UIFont.chatUIKit(name: "GothamNarrow-Bold", size: 12) else {
            assertionFailure("Missing font GothamNarrow-Bold size 12, check test and assets")
            return UIFont.systemFont(ofSize: 12) }
        return font }
    static var chatFontBoddy:UIFont {
        guard let font = UIFont.chatUIKit(name: "GothamNarrow-Bold", size: 15) else {
            assertionFailure("Missing font GothamNarrow-Bold size 15, check test and assets")
            return UIFont.systemFont(ofSize: 15) }
        return font }
    
    static func chatColor(sender:Sender) -> UIColor {
        let chatGray = UIColor.chatUIKit(named: "ChatGray") ?? UIColor.gray
        let chatLightGray = UIColor.chatUIKit(named: "ChatLightGray") ?? UIColor.lightGray
        return sender != Sender.right ? chatGray : chatLightGray
    }
    
    fileprivate var attributedHeader:NSAttributedString? {
        let bubbleDescription = self.description
        let color = BubbleData.chatColor(sender: bubbleDescription.sender)
        
        if let header = self.text.header {
            if (bubbleDescription.position & Position.First) == Position.First {
                return NSAttributedString (
                    string: header + "\n",
                    attributes:[
                        NSAttributedString.Key.font: BubbleData.chatFontInfo,
                        NSAttributedString.Key.foregroundColor: color,
                        NSAttributedString.Key.backgroundColor: UIColor.clear ] ) } }
        return nil }
    
    fileprivate var attributedBoddy:NSAttributedString {
        let boddy = self.text.boddy
        
        let bubbleDescription = self.description
        var color:UIColor!
        if (bubbleDescription.sender != Sender.right) { color = UIColor.black }
        else { color = UIColor.white }
        
        return NSAttributedString (
            string: boddy + "\n",
            attributes:[
                NSAttributedString.Key.font: BubbleData.chatFontBoddy,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.backgroundColor: UIColor.clear ] ) }
    
    fileprivate var attributedFooterLead:NSAttributedString? {
        let bubbleDescription = self.description
        let color = BubbleData.chatColor(sender: bubbleDescription.sender)
        
        if let footerLead = self.text.footerLead {
            if (bubbleDescription.position & Position.Last) == Position.Last {
                return NSAttributedString (
                    string: footerLead,
                    attributes:[
                        NSAttributedString.Key.font: BubbleData.chatFontInfo,
                        NSAttributedString.Key.foregroundColor: color,
                        NSAttributedString.Key.backgroundColor: UIColor.clear ] ) } }
        return nil }
    
    fileprivate var attributedFooter:NSAttributedString? {
        let bubbleDescription = self.description
        let color = BubbleData.chatColor(sender: bubbleDescription.sender)
        
        if let footer = self.text.footer {
            return NSAttributedString (
                string: footer,
                attributes:[
                    NSAttributedString.Key.font: BubbleData.chatFontInfo,
                    NSAttributedString.Key.foregroundColor: color,
                    NSAttributedString.Key.backgroundColor: UIColor.clear ] ) }
        return nil }
    
    var attributedText:NSAttributedString {
        get {
            let attributedText = NSMutableAttributedString()
            var length = Int(0)
            let paragraphStyleLeft = NSParagraphStyle()
            let paragraphStyleRight = NSMutableParagraphStyle()
            paragraphStyleRight.alignment = .right
            // Attributed Header
            if (description.position & Position.First) == Position.First,
                let attributedHeader = self.attributedHeader {
                attributedText.append(attributedHeader)
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                            value: paragraphStyleRight,
                                            range: NSMakeRange(length, attributedHeader.length))
                length += attributedHeader.length }
            // Attributed Boddy
            let attributedBoddy = self.attributedBoddy
            attributedText.append(attributedBoddy)
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                        value: paragraphStyleLeft,
                                        range: NSMakeRange(length, attributedBoddy.length))
            length += attributedBoddy.length
            // Attributed Footer Lead
            if let _ = self.attributedFooter,
                let attributedFooterLead = self.attributedFooterLead {
                attributedText.append(attributedFooterLead)
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                            value: paragraphStyleRight,
                                            range: NSMakeRange(length, attributedFooterLead.length))
                length += attributedFooterLead.length }
            // Attributed Footer
            if let attributedFooter = self.attributedFooter {
                attributedText.append(attributedFooter)
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                            value: paragraphStyleRight,
                                            range: NSMakeRange(length, attributedFooter.length)) }
            return attributedText } }
}
