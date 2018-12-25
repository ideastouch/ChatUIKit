//
//  ViewController.swift
//  ChatUIKittest
//
//  Created by Gustavo Halperin on 12/16/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import UIKit
import ChatUIKit

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
            var owner = Person(name:"Paul")
            if let messages = MockChat.shared?.messages,
                let first = messages.first(where: { $0.sender?.name == owner.name }),
                let objectId = first.sender?.objectId {
                owner.objectId = objectId
            }
            self.owner = owner
            let chatDataSource = ChatDataSource<PersonMessage, Person>(owner: owner, otherName:"Admin")
            if let messages = MockChat.shared?.messages {
                chatDataSource.chatList = messages
            }
            chatViewController.dataSource = chatDataSource
            chatViewController.delegate = chatDataSource
            chatViewController.sendMessageBlock = { (_ message:String, _ succed:@escaping ()->Void) in
                guard let chatDataSource = chatViewController.dataSource as? ChatDataSource<PersonMessage, Person> else { return }
                var personMessage = PersonMessage()
                personMessage.message = message
                personMessage.sender = self.owner
                if chatDataSource.chatList.contains( where: { $0 == personMessage } ) { return }
                chatDataSource.chatList.append(personMessage)
                chatViewController.tableView.reloadData()
                chatViewController.resetTablePosition()
                succed() }
        }
    }


}

