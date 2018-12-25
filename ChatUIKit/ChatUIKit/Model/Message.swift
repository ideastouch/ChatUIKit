//
//  Message.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/23/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation

public protocol Message {
    associatedtype Sender:SenderProtocol
    var message: String? { get }
    var sender: Sender? { get }
    var timeStr: String? { get }
    var dayStr: String? { get }
}
