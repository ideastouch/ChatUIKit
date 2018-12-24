//
//  MockChat.swift
//  ChatUIKittest
//
//  Created by Gustavo Halperin on 12/23/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit
import ChatUIKit

class MockChat {
    var messages: [PersonMessage]
    static let shared = MockChat()
    private init?() {
        guard let path = Bundle(for: type(of : self)).path(forResource: "MockedMessages", ofType: "plist"),
            let pathURL = URL(string: "file://" + path) else { return nil }
        do {
            let data = try Data(contentsOf: pathURL)
            typealias PersonMessages = [PersonMessage]
            let personMessages = try PropertyListDecoder().decode(PersonMessages.self, from: data)
            self.messages = personMessages
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
}
