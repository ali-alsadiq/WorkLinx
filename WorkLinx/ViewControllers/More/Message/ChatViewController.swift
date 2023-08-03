import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "WorkLinx")
    let otherUser: Sender
    var messages = [MessageType]()
    
    init(selectedUser: String) {
        self.otherUser = Sender(senderId: "other", displayName: selectedUser)
        super.init(nibName: nil, bundle: nil)
        
        // Add messages only if the selected user is "John Smith"
        if selectedUser == "John Smith" {
            messages.append(Message(sender: currentUser, messageId: "1",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("Hello nice to meet you")))
            
            messages.append(Message(sender: otherUser, messageId: "2",
                                    sentDate: Date().addingTimeInterval(-76400),
                                    kind: .text("Hello there, me too")))
            
            messages.append(Message(sender: currentUser, messageId: "3",
                                    sentDate: Date().addingTimeInterval(-66400),
                                    kind: .text("How is it going?")))
            
            messages.append(Message(sender: otherUser, messageId: "4",
                                    sentDate: Date().addingTimeInterval(-56400),
                                    kind: .text("Great Thanks! How about you?")))
            
            messages.append(Message(sender: currentUser, messageId: "5",
                                    sentDate: Date().addingTimeInterval(-46400),
                                    kind: .text("I am doing great. by the way, have you got my resume?")))
            
            messages.append(Message(sender: otherUser, messageId: "6",
                                    sentDate: Date().addingTimeInterval(-36400),
                                    kind: .text("Not yet")))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title to the selected user's name
        navigationItem.title = otherUser.displayName

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // Set the delegate for the input bar
        messageInputBar.delegate = self
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // InputBarAccessoryViewDelegate method to handle sending messages
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        // Create a new message and add it to the messages array
        let newMessage = Message(sender: currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messages.append(newMessage)
        
        // Reload the collection view to display the new message
        messagesCollectionView.reloadData()
        
        // Scroll to the bottom to show the latest message
        messagesCollectionView.scrollToBottom(animated: true)
        
        // Clear the input text
        inputBar.inputTextView.text = ""
    }
}
