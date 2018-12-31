//
//  PersonMessage.swift
//  ChatUIKittest
//
//  Created by Gustavo Halperin on 12/23/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit
import ChatUIKit

struct PersonMessage: Message, Codable {
    static var objectIdSet = Set<String>()
//    typealias Sender = Person
    var objectId: String?
    var date: Date?
    var message: String?
    var sender: Person?
    var timeStr: String? { get { return self.date?.chatUIKitTimeStr  } }
    var dayStr: String? { get { return self.date?.chatUIKitDayStr } }
    init() {
        self.date = Date()
        for _ in 0..<10 {
            let objectId = String.randomName(length: 9)
            if PersonMessage.objectIdSet.contains(objectId) { continue }
            self.objectId = objectId
        }
        assert(self.objectId != nil, "Failure generatin object Id")
    }
    public static func == (lhs: PersonMessage, rhs: PersonMessage) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}
