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

class PersonMessage: Message, Codable {
    static var objectIdSet = Set<String>()
    typealias Sender = Person
    var objectId: String?
    var date: Date?
    var message: String?
    var sender: Sender?
    lazy var timeStr: String? = self.date?.chatUIKitTimeStr
    lazy var dayStr: String? = self.date?.chatUIKitDayStr
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
    
    // Protocol Codable
    enum CodingKeys: String, CodingKey {
        case objectId
        case message
        case sender
        case date
    }
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try values.decode(String.self, forKey: .objectId)
        self.message = try values.decode(String.self, forKey: .message)
        self.sender = try? values.decode(Sender.self, forKey: .sender)
        self.date = try? values.decode(Date.self, forKey: .date)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.objectId, forKey: .objectId)
        try container.encode(self.message, forKey: .message)
        try? container.encode(self.sender, forKey: .sender)
        try container.encode(self.date, forKey: .date)
    }
}
