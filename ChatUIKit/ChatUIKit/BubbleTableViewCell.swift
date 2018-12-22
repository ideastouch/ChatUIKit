//
//  BubbleTableViewCell.swift
//  TroupeFit
//
//  Created by Gustavo Halperin on 1/18/16.
//  Copyright © 2016 TroupeFit LLC. All rights reserved.
//

import UIKit

// Bubble Image sizes
// 43,32
// 13,6,  22x16 -> 8,10
// horizontal: 8 and 13
// vertical  : 6, 10
class BubbleData {
    class Position {
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
        // TODO: Add test cases for both colors.
        let chatGray = UIColor.chatUIKit(named: "ChatGray") as? UIColor ?? UIColor.gray
        let chatLightGray = UIColor.chatUIKit(named: "ChatLightGray") as? UIColor ?? UIColor.lightGray
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
            if (description.position & Position.First) == Position.First {
                if let attributedHeader = self.attributedHeader {
                    attributedText.append(attributedHeader)
                    attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                                value: paragraphStyleRight,
                                                range: NSMakeRange(length, attributedHeader.length))
                    length += attributedHeader.length } }
            let attributedBoddy = self.attributedBoddy
            attributedText.append(attributedBoddy)
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                        value: paragraphStyleLeft,
                                        range: NSMakeRange(length, attributedBoddy.length))
            length += attributedBoddy.length
            if let attributedFooter = self.attributedFooter {
                if let attributedFooterLead = self.attributedFooterLead {
                    attributedText.append(attributedFooterLead)
                    attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                                value: paragraphStyleRight,
                                                range: NSMakeRange(length, attributedFooterLead.length))
                    length += attributedFooterLead.length }
                attributedText.append(attributedFooter)
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                            value: paragraphStyleRight,
                                            range: NSMakeRange(length, attributedFooter.length)) }
            return attributedText } }
}

class BubbleTableViewCell : UITableViewCell {
    var bubbleData:BubbleData? {
        didSet {
            if let bubbleData = self.bubbleData {
                if let named = bubbleData.name {
                    let image = UIImage.chatUIKit(named: named)
                    if let imageSize = image?.size {
                        let height = imageSize.height * 0.5
                        let width = imageSize.width * 0.5
                        let insets = UIEdgeInsets(top: height, left: width, bottom: height, right: width)
                        if let image = image?.resizableImage(withCapInsets: insets, resizingMode: .stretch) {
                            self.bubbleImageView = UIImageView(image: image)
                        } } }
                if let bubbleImageView = self.bubbleImageView {
                    self.textLabel?.isHidden = true
                    let customTextLabel = UILabel(frame: self.bubbleInnerFrame)
                    customTextLabel.attributedText = bubbleData.attributedText
                    customTextLabel.lineBreakMode = .byWordWrapping
                    customTextLabel.numberOfLines = 0
                    customTextLabel.backgroundColor = UIColor.clear
                    customTextLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    customTextLabel.isUserInteractionEnabled = true
                    bubbleImageView.addSubview(customTextLabel) } } } }

    override func prepareForReuse() {
        self.bubbleImageView?.removeFromSuperview()
        self.bubbleImageView = nil
        self.textLabel?.text = nil
        self.textLabel?.attributedText = nil }
    
    
    static fileprivate let innerSize: (innerWidth:CGFloat, outerWidth:CGFloat, topHeight:CGFloat, bottomHeight:CGFloat) = (13, 8, 6, 10)
    
    class func heightWithAttributedString(_ attributedString: NSAttributedString, width:CGFloat) -> CGFloat {
        let (innerWidth, outerWidth, topHeight, bottomHeight) = BubbleTableViewCell.innerSize
        let w = width - ( BubbleTableViewCell.bubbleOffset + innerWidth + outerWidth )
        if w > 0 {
            let size = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)
            let labelSize = attributedString.boundingRect(
                with: size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                context: nil)
            return labelSize.height + topHeight + bottomHeight }
        return UITableView.automaticDimension }
    
    var bubbleImageView: UIImageView? {
        didSet {
            if let imageView = self.bubbleImageView {
                self.contentView.insertSubview(imageView, at: 0)
                var frame:CGRect!
                if let bubbleFrame = self.bubbleFrame { frame = bubbleFrame }
                else { frame = self.contentView.frame}
                imageView.frame = frame
                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                imageView.isUserInteractionEnabled = true } } }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate class var bubbleOffset:CGFloat { return 48 }
    fileprivate var bubbleFrame:CGRect? {
        get {
            var frame = self.contentView.frame
            if let bubbleDescription = self.bubbleData?.description {
                if frame.size.width < BubbleTableViewCell.bubbleOffset { return nil }
                frame.size.width -= BubbleTableViewCell.bubbleOffset
                if bubbleDescription.sender == .right { frame.origin = CGPoint(x:BubbleTableViewCell.bubbleOffset, y:0) }
                else { frame.origin = CGPoint.zero } }
            return frame } }
    
    fileprivate var bubbleInnerFrame:CGRect {
        get {
            if var frame = self.bubbleFrame {
                let (innerWidth, outerWidth, topHeight, bottomHeight) = BubbleTableViewCell.innerSize
                frame.size.width -= innerWidth + outerWidth
                frame.size.height -= topHeight + bottomHeight
                if frame.size.width < 0 || frame.size.height < 0 { return self.contentView.frame }
                if let sender = self.bubbleData?.description.sender {
                    if sender == .right { frame.origin = CGPoint(x:outerWidth, y: topHeight) }
                    else { frame.origin = CGPoint(x: innerWidth, y: outerWidth) } }
                return frame }
            return self.contentView.frame } }
}
