//
//  ChatDataSource.swift
//  TroupeFit
//
//  Created by Gustavo Halperin on 12/16/18.
//  Copyright © 2018 TroupeFit LLC. All rights reserved.
//

import UIKit

protocol SenderProtocol: Equatable {
    var objectId: String? { get }
    var name: String? { get } }

protocol Message {
    associatedtype Sender:SenderProtocol
    var message: String? { get }
    var sender: Sender? { get }
    var timeStr: String? { get }
    var dayStr: String? { get } }

class ChatDataSource<M:Message, SP:SenderProtocol>: NSObject, UITableViewDataSource, UITableViewDelegate {
    var owner:SP
    var chatList = [M]()
    var senderName:String
    var otherName:String
    init(owner:SP, otherName:String, senderName:String = "Me") {
        self.owner = owner
        self.otherName = otherName
        self.senderName = senderName }
    
    fileprivate func positionToBubbleSender(_  index:Int) -> BubbleData.Sender {
        if index < 0 || index >= self.chatList.count { return BubbleData.Sender.none }
        let chat = self.chatList[index]
        guard let sender =  chat.sender else {
            return BubbleData.Sender.other }
        if sender.objectId == self.owner.objectId {
            return BubbleData.Sender.right }
        else { return BubbleData.Sender.left } }
    
    fileprivate func senderHeader(_ sender:BubbleData.Sender, chat:M) -> String? {
        switch sender {
        case BubbleData.Sender.right:
            return self.senderName
        case BubbleData.Sender.left:
            return chat.sender?.name
        case BubbleData.Sender.other:
            return self.otherName
        default:
            return nil }
    }
    
    fileprivate func bubbleData(_ indexPath: IndexPath) -> BubbleData? {
        let index = indexPath.row
        let chat = self.chatList[index]
        guard let boddy = chat.message else { return nil }
        let prevSender = self.positionToBubbleSender(index - 1)
        let sender = self.positionToBubbleSender(index)
        let nextSender = positionToBubbleSender(index + 1)
        
        let header = self.senderHeader(sender, chat:chat)
        let position =  BubbleData.senderGroupToPosition(prevSender, current: sender, next: nextSender)
        let description = (position:position, sender:sender)
        let footer = chat.timeStr
        let footerLead:String? = chat.dayStr != nil ? "\(chat.dayStr!), " : nil
        let text = (header:header, boddy:boddy, footerLead:footerLead, footer:footer)
        
        return  BubbleData(description: description, text: text) }
    
    // Protocol UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatList.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let bubbleData = self.bubbleData(indexPath) {
            let attributedText = bubbleData.attributedText
            let height = BubbleTableViewCell.heightWithAttributedString(attributedText, width: tableView.frame.size.width)
            return height }
        return UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatViewController.CellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        if let bubbleTableViewCell = cell as? BubbleTableViewCell {
            bubbleTableViewCell.bubbleData = self.bubbleData(indexPath) }
        return cell }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: Should be one section for each day.
        return 1 }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //TODO: Shoul be the date of the first message sent on this section.
        return nil  }
}
