//
//  ChatUIKittestTests.swift
//  ChatUIKittestTests
//
//  Created by Gustavo Halperin on 12/24/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import XCTest

class ChatUIKittestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testPerson() {
        enum PersonError: Error {
            case PersonIsNill
        }
        let person = Person(name: "Paul")
        do {
            let jsonData = try JSONEncoder().encode(person)
            let decoder = try JSONDecoder().decode(Person.self, from: jsonData)
            XCTAssertTrue(decoder == person)
            XCTAssertTrue(decoder.objectId == person.objectId)
            XCTAssertTrue(decoder.name == person.name)
        }
        catch {
            XCTFail()
        }
    }
    func testPersonMessage() {
        enum MessageDIError: Error {
            case IsNill
        }
        let sender = Person(name:"Paul")
        var personMessage = PersonMessage()
        personMessage.sender = sender
        personMessage.message = "My Message"
        personMessage.date = Date()
        do {
            let jsonData = try JSONEncoder().encode(personMessage)
            let decoder = try JSONDecoder().decode(PersonMessage.self, from: jsonData)
            XCTAssertTrue(decoder == personMessage)
            XCTAssertTrue(decoder.objectId == personMessage.objectId)
            XCTAssertTrue(decoder.sender == personMessage.sender)
            XCTAssertTrue(decoder.sender?.objectId == personMessage.sender?.objectId)
            XCTAssertTrue(decoder.sender?.name == personMessage.sender?.name)
            XCTAssertTrue(decoder.message == personMessage.message)
            XCTAssertTrue(decoder.date == personMessage.date)
        }
        catch {
            XCTFail()
        }
    }
}
