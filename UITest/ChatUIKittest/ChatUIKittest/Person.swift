//
//  Person.swift
//  ChatUIKittest
//
//  Created by Gustavo Halperin on 12/23/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation
import UIKit
import ChatUIKit

class Person: SenderProtocol, Codable {
    static var objectIdSet = Set<String>()
    var objectId: String?
    var name: String?
    init(name:String) {
        for _ in 0..<10 {
            let objectId = String.randomName(length: 9)
            if Person.objectIdSet.contains(objectId) { continue }
            self.objectId = objectId
        }
        assert(self.objectId != nil, "Failure generatin object Id")
        self.name = name
    }
    public static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.objectId == rhs.objectId
    }
    
    // Protocol Codable
    enum CodingKeys: String, CodingKey {
        case objectId
        case name
    }
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try values.decode(String.self, forKey: .objectId)
        self.name = try values.decode(String.self, forKey: .name)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.objectId, forKey: .objectId)
        try container.encode(self.name, forKey: .name)
        
    }
}
