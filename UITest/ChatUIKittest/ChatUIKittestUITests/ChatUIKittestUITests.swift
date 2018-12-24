//
//  ChatUIKittestUITests.swift
//  ChatUIKittestUITests
//
//  Created by Gustavo Halperin on 12/16/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import XCTest

class ChatUIKittestUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments.append("MockChat")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChat() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tapTextView = { () in
            app.otherElements.containing(.navigationBar, identifier:"Messages").children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element(boundBy: 1).children(matching: .other)
            .element.children(matching: .textView)
            .element.tap()
        }
        
        tapTextView()
        app.typeText("Great weather today!!")
        app.buttons["Return"].tap()
        app.typeText("Let's go surf")
        app.buttons["Send"].tap()
        tapTextView()
        app.typeText("Thats it")
        app.buttons["Send"].tap()
        tapTextView()
        app.tables.staticTexts["Me\nOK, We all here now\n10:28AM"].tap()
 
    }

}
