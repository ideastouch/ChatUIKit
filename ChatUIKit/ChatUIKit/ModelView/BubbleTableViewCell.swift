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
                            self.bubbleImageView = UIImageView(image: image) } } }
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
        super.init(style: .value1, reuseIdentifier: reuseIdentifier) }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") }
    
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
