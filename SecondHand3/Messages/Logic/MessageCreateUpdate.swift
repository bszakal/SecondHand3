//
//  MessageCreateUpdate.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 15/11/22.
//

import Foundation

protocol MessageCreateUpdateProtocol {
    func createNewMessage(announceID: String, receiverID: String, messageContent: String) async
    func amendMessagesToRead(messages: [Message])
}

class MessageCreateUpdate: MessageCreateUpdateProtocol {
    
    @Inject private var firebaseMEssage: FirebaseMessageProtocol
    
    func createNewMessage(announceID: String, receiverID: String, messageContent: String) async {
        
        let resUserId = await firebaseMEssage.getuserUID()
        switch resUserId {
        case .success(let userID):

        let message = Message(announceID: announceID, ids: [userID, receiverID], senderID: userID, receiverID: receiverID, messageContent: messageContent, hasBeenRead: false)
            firebaseMEssage.addNewMessage(message: message)
            
        case .failure(let error):
            print(error.localizedDescription)
            return
        }
    }
    
    func amendMessagesToRead(messages: [Message]) {
        var messagesSetToRead = messages
        for index in messagesSetToRead.indices {
            messagesSetToRead[index].hasBeenRead = true
        }
        if !messagesSetToRead.isEmpty{
            firebaseMEssage.setMessageToReadStatus(messages: messagesSetToRead)
        }
    }
    

}
