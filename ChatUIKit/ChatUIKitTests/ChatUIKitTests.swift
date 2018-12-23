//
//  ChatUIKitTests.swift
//  ChatUIKitTests
//
//  Created by Gustavo Halperin on 12/16/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit
import XCTest
@testable import ChatUIKit

class ChatUIKitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testResources() {
        /* Bundle Loading */
        XCTAssertNotNil(ChatUIKit.bundle(), "ChatUIKit Bundle")
        /* Images */
        XCTAssertNotNil(UIImage.chatUIKit(named: BubbleData.Name.BubbleRight.rawValue), "UIImage BubbleRight")
        XCTAssertNotNil(UIImage.chatUIKit(named: BubbleData.Name.TalkRight.rawValue), "UIImage TalkRight")
        XCTAssertNotNil(UIImage.chatUIKit(named: BubbleData.Name.BubbleLeft.rawValue), "UIImage BubbleLeft")
        XCTAssertNotNil(UIImage.chatUIKit(named: BubbleData.Name.TalkLeft.rawValue), "UIImage TalkLeft")
        XCTAssertNotNil(UIImage.chatUIKit(named: BubbleData.Name.BubbleOther.rawValue), "UIImage BubbleOther")
        XCTAssertNotNil(UIImage.chatUIKit(named: BubbleData.Name.TalkOther.rawValue), "UIImage TalkOther")
        /* Fonts */
        XCTAssertNotNil(UIFont.chatUIKit(name: "GothamNarrow-Bold", size: 12), "Font GothamNarrow-Bold, 12")
        XCTAssertNotNil(UIFont.chatUIKit(name: "GothamNarrow-Bold", size: 15), "Font GothamNarrow-Bold, 15")
        /* Colors */
        XCTAssertNotNil(UIColor.chatUIKit(named: "ChatGray"), "Color ChatGray")
        XCTAssertNotNil(UIColor.chatUIKit(named: "ChatLightGray"), "Color ChatLightGray")
    }

    func testBubbleDataSources() {
        XCTAssertTrue(BubbleData.chatFontInfo ==  UIFont.chatUIKit(name: "GothamNarrow-Bold", size: 12))
        XCTAssertTrue(BubbleData.chatFontBoddy ==  UIFont.chatUIKit(name: "GothamNarrow-Bold", size: 15))
        XCTAssertTrue(BubbleData.chatColor(sender:.right) ==  UIColor.chatUIKit(named: "ChatGray"))
        XCTAssertTrue(BubbleData.chatColor(sender:.none) ==  UIColor.chatUIKit(named: "ChatLightGray"))
        XCTAssertTrue(BubbleData.chatColor(sender:.left) ==  UIColor.chatUIKit(named: "ChatLightGray"))
        XCTAssertTrue(BubbleData.chatColor(sender:.other) ==  UIColor.chatUIKit(named: "ChatLightGray"))
    }
    
    func testBubbleDataLogic() {
        // ::senderGroupToPosition
        // First and Last
        var position = BubbleData.senderGroupToPosition(.none, current: .left, next: .none)
        XCTAssertTrue(position == BubbleData.Position.First | BubbleData.Position.Last)
        position = BubbleData.senderGroupToPosition(.none, current: .right, next: .none)
        XCTAssertTrue(position == BubbleData.Position.First | BubbleData.Position.Last)
        position = BubbleData.senderGroupToPosition(.none, current: .other, next: .none)
        XCTAssertTrue(position == BubbleData.Position.First | BubbleData.Position.Last)
        // First but Last
        position = BubbleData.senderGroupToPosition(.none, current: .left, next: .left)
        XCTAssertTrue(position == BubbleData.Position.First)
        position = BubbleData.senderGroupToPosition(.none, current: .right, next: .right)
        XCTAssertTrue(position == BubbleData.Position.First)
        position = BubbleData.senderGroupToPosition(.none, current: .other, next: .other)
        XCTAssertTrue(position == BubbleData.Position.First)
        // Last but First
        position = BubbleData.senderGroupToPosition(.left, current: .left, next: .none)
        XCTAssertTrue(position == BubbleData.Position.Last)
        position = BubbleData.senderGroupToPosition(.right, current: .right, next: .none)
        XCTAssertTrue(position == BubbleData.Position.Last)
        position = BubbleData.senderGroupToPosition(.other, current: .other, next: .none)
        XCTAssertTrue(position == BubbleData.Position.Last)
        // Middle
        position = BubbleData.senderGroupToPosition(.left, current: .left, next: .left)
        XCTAssertTrue(position == BubbleData.Position.Middle)
        position = BubbleData.senderGroupToPosition(.right, current: .right, next: .right)
        XCTAssertTrue(position == BubbleData.Position.Middle)
        position = BubbleData.senderGroupToPosition(.other, current: .other, next: .other)
        XCTAssertTrue(position == BubbleData.Position.Middle)
    }
}
