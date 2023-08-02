//
//  ChatViewController.swift
//  WorkLinx
//
//  Created by Alex Wang on 2023-08-02.
//

import UIKit
import MessageKit


struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "WorkLinx")
    let otherUser = Sender(senderId: "other", displayName: "John Smith")

    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(sender: currentUser, messageId: "1",
                                sentDate: Date().addingTimeInterval(-86400),
                                kind: .text("Hello Alex")))
        
        messages.append(Message(sender: currentUser, messageId: "2",
                                sentDate: Date().addingTimeInterval(-76400),
                                kind: .text("Hello John")))
        
        messages.append(Message(sender: currentUser, messageId: "3",
                                sentDate: Date().addingTimeInterval(-66400),
                                kind: .text("How is it going?")))
        
        messages.append(Message(sender: currentUser, messageId: "4",
                                sentDate: Date().addingTimeInterval(-56400),
                                kind: .text("Great Thanks! How about you?")))
        
        messages.append(Message(sender: currentUser, messageId: "5",
                                sentDate: Date().addingTimeInterval(-46400),
                                kind: .text("I am doing great. by the way, have you got my resume?")))
        
        messages.append(Message(sender: currentUser, messageId: "6",
                                sentDate: Date().addingTimeInterval(-36400),
                                kind: .text("Not yet, John")))
        
        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    
    func currentSender() -> MessageKit.SenderType {
        return currentUser    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
