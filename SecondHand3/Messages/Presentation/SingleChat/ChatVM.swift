//
//  ChatVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 14/11/22.
//
import Combine
import SwiftUI

@MainActor
class ChatVM: ObservableObject {
    
    @Inject var messageGet: MessageGetProtocol
    @Inject var messageCreateUdate: MessageCreateUpdateProtocol
    
    @Published private(set) var chat = Chat(id: "", announceID: "", idOtherUser: "", messages: [])
    @Published private(set) var dates = [Date]()
    @Published private(set) var isChatLoaded = false
    
    var cancellables = Set<AnyCancellable>()

    
    init(announceId: String, announceUserId: String) {
        self.chat = initialiseChat(announceId: announceId, announceUserID: announceUserId)
        self.chat.messages.sort()
    }
    
    func suscribeChatLiveData() {

        messageGet.chatPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                
                //only update for the wanted Chat
                let chats = newValue.filter{$0.id == self?.chat.id}
                
                if !chats.isEmpty {
                    var selectedChat = chats[0]
                    selectedChat.messages.sort()
                    self?.chat = selectedChat
                    self?.getUniqueDates()
                    self?.isChatLoaded = true
                }
                
            }
            .store(in: &cancellables)
    }
    
    func messageSentByUser(message: Message) -> Bool {
        messageGet.messageSentByUser(message: message)
    }
    
    func getUniqueDates() {
        
        var dateSet = Set<Date>()
        for mess in self.chat.messages {
            if let createdAt = mess.createdAt {
                let dateComponent = Calendar.current.dateComponents([.day, .month, .year], from: createdAt)
                if let date = Calendar.current.date(from: dateComponent) {
                    dateSet.insert(date)
                }
            }
        }
        
        self.dates = dateSet.map{$0}
    }
    
    func areDatesSameDay(dateGroup: Date, dateMessage: Date) -> Bool {
        return Calendar.current.isDate(dateGroup, equalTo: dateMessage, toGranularity: .day)
    }
    
    func sendMessage(content: String) {
        Task{
           await messageCreateUdate.createNewMessage(announceID:chat.announceID, receiverID:chat.idOtherUser, messageContent: content)
        }
    }
    
    func amendMessagesToRead(messages: [Message]) {
        
        let messagesReceived = messages.filter{messageSentByUser(message:$0) == false}
        let receivedAndUnread = messagesReceived.filter{$0.hasBeenRead == false}
        messageCreateUdate.amendMessagesToRead(messages: receivedAndUnread)
    }
    
    func initialiseChat(announceId: String, announceUserID: String) ->Chat {
       return messageGet.returnNewOrExistingChat(announceId: announceId, announceUserId: announceUserID)
    }
    
}
