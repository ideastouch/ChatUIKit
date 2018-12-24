//
//  Sender.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/23/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation


public protocol SenderProtocol: Equatable {
    var objectId: String? { get }
    var name: String? { get }
}
