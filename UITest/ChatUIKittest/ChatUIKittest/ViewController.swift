//
//  ViewController.swift
//  ChatUIKittest
//
//  Created by Gustavo Halperin on 12/16/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit
import ChatUIKit


func RandomNameString(length: Int = 9)->String{
    enum s {
        static let c = Array("abcdefghjklmnpqrstuvwxyz12345789")
        static let k = UInt32(c.count)
    }
    var result = [Character](repeating: "a", count: length)
    for i in 0..<length {
        let r = Int(arc4random_uniform(s.k))
        result[i] = s.c[r]
    }
    return String(result)
}

class Person: SenderProtocol {
    static var objectIdSet = Set<String>()
    var objectId: String?
    var name: String?
    init(name:String) {
        for _ in 0..<10 {
            let objectId = RandomNameString(length: 9)
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

class PersonMessage: Message {
    static var objectIdSet = Set<String>()
    typealias Sender = Person
    var objectId: String?
    var message: String?
    var sender: Sender?
    var timeStr: String?
    var dayStr: String?
    init() {
        for _ in 0..<10 {
            let objectId = RandomNameString(length: 9)
            if PersonMessage.objectIdSet.contains(objectId) { continue }
            self.objectId = objectId
        }
        assert(self.objectId != nil, "Failure generatin object Id")
    }
    public static func == (lhs: PersonMessage, rhs: PersonMessage) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}

class ViewController: UIViewController {
    var chatViewController : ChatViewController?
    var owner:Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Person.objectIdSet.removeAll()
        PersonMessage.objectIdSet.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier  == "ViewControllerToChatViewControllerSegue",
            let chatViewController = segue.destination as? ChatViewController {
            self.chatViewController = chatViewController
            let owner = Person(name:"Gus")
            self.owner = owner
            let chatDataSource = ChatDataSource<PersonMessage, Person>(owner: owner, otherName:"Admin")
            chatViewController.dataSource = chatDataSource
            chatViewController.delegate = chatDataSource
            chatViewController.sendMessageBlock = { (_ message:String, _ succed:@escaping ()->Void) in
                guard let chatDataSource = chatViewController.dataSource as? ChatDataSource<PersonMessage, Person> else { return }
                let personMessage = PersonMessage()
                personMessage.message = message
                personMessage.sender = self.owner
                personMessage.timeStr = "Now"
                personMessage.dayStr = "Today"
                if chatDataSource.chatList.contains( where: { $0 == personMessage } ) { return }
                chatDataSource.chatList.append(personMessage)
                chatViewController.tableView.reloadData()
                chatViewController.resetTablePosition()
                succed() }
        }
    }


}

