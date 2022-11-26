//
//  MessageGet.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//
import Combine
import Foundation

protocol MessageGetProtocol {
    
    var chatPublisher: Published<[Chat]>.Publisher {get}
    func getUnredMessagesForChat(chat: Chat) -> Int
    func messageSentByUser(message: Message) -> Bool
    func getMessagesForUser2()
    func returnNewOrExistingChat(announceId: String, announceUserId: String) -> Chat
}

class MessageGet: MessageGetProtocol {
    
    
    @Published private(set) var chats = [Chat]()
    var chatPublisher: Published<[Chat]>.Publisher{$chats}
    
    enum LoginState {
        case loggedIn (String)
        case NotLoggedIn
    }
    enum ErrorType: Error {
        case userNotLoggedIn
    }
    private var loginState = LoginState.NotLoggedIn
    
    @Inject private var firebaseMEssage: FirebaseMessageProtocol
    
    init() {
        getMessagesForUser2()
    }
    
    
  
    
    private func getIdOtherUser(ids: [String]) async -> String {
        
        let resUserId = await firebaseMEssage.getuserUID()
        switch resUserId {
        case .success(let success):
            self.loginState = .loggedIn(success)
            let otheruser = ids.filter{$0 != success}
            return otheruser[0]
  
        case .failure(let failure):
            print(failure.localizedDescription)
            return ""
        }
    }
    
    func getUnredMessagesForChat(chat: Chat) -> Int {
                
        switch self.loginState {
        case .NotLoggedIn:
            return 0
        case .loggedIn(let userID):
            return chat.messages.filter{$0.hasBeenRead == false && $0.senderID != userID}.count
        }
    }
    
    func messageSentByUser(message: Message) -> Bool {
        
        switch self.loginState {
        case .NotLoggedIn:
            return false
        case .loggedIn(let userID):
            return message.senderID == userID ? true : false
        }
    }
    
    func getMessagesForUser2() {
        
        firebaseMEssage.getMessages2 { messages, err in
            
            if let error = err {
                print(error.localizedDescription)
            } else {
                Task {
                for message in messages {
                    
                    let otherID = await self.getIdOtherUser(ids: message.0.ids)

                            if let index = self.chats.firstIndex(where: { chat in
                                chat.id == (message.0.announceID + otherID)
                            }) {
                                switch message.1 {
                                case .Added :
                                    self.chats[index].messages.append(message.0)
                                case .Removed:
                                    self.chats[index].messages.removeAll(where: {$0.id == message.0.id})
                                case .Modified:
                                    if let messageIndex = self.chats[index].messages.firstIndex(where:{$0.id == message.0.id}) {
                                        self.chats[index].messages[messageIndex] = message.0
                                    }
                                }
                                
                            } else {
                                self.chats.append(Chat(id: (message.0.announceID + otherID), announceID: message.0.announceID, idOtherUser: otherID, messages: [message.0]))
                            }

                    }
                }
                

            }
        }
    }
    
    func returnNewOrExistingChat(announceId: String, announceUserId: String) -> Chat {
        if let index = self.chats.firstIndex(where:{$0.id == announceId + announceUserId}) {
            return self.chats[index]
        } else {
            return Chat(id: announceId + announceUserId, announceID: announceId, idOtherUser: announceUserId, messages: [])
        }
   }

}
