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

struct Person: SenderProtocol, Codable {
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
}
