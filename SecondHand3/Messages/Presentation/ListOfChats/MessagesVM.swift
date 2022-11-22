//
//  MessagesVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//
import Combine
import SwiftUI

@MainActor
class MessagesVM: ObservableObject {
    
    @Inject var userGet: GetUserProfileProtocol
    @Inject var announceGet: AnnounceRepoProtocol
    @Inject var messageGet: MessageGetProtocol
    
    
    @Published private(set) var chats = [Chat]()
    @Published private(set) var userProfileForChat = [String:UserProfile]()
    @Published private(set) var currentUserProfile = UserProfile(id: "", emailAddress: "")
    @Published private(set) var announceForChat = [String:Announce]()
    
    
    var cancellables = Set<AnyCancellable>()
    
    init(){
        getCurrentUserProfile()
        getMessages()
    }
    
    func getMessages() {
       
        messageGet.chatPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                    for chat in newValue {
                        self?.getAnnounce(chat: chat)
                        self?.getUserProfile(chat: chat)
                    }

                self?.chats = newValue
            }
            .store(in: &cancellables)
    }
    
    func getUserProfile(chat: Chat) {

        Task {
            //only add the value to userProfile Dico if it doesn't already exists for this chat
            if let _ = self.userProfileForChat[chat.id] {
            } else {
                let userProfileResult = await userGet.getUserProfileForUserId(userID: chat.idOtherUser)
                switch userProfileResult {
                case .success(let success):
                    
                    self.userProfileForChat[chat.id] = success
                    
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func getCurrentUserProfile() {
        Task {
            let userProfileResult = await userGet.getUserProfile()
            switch userProfileResult {
            case .success(let success):
                self.currentUserProfile = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
    }
    
    func getAnnounce(chat: Chat) {

        Task {
            //only add the value to announceForChat Dico if it doesn't already exists for this chat
            if let _ = self.announceForChat[chat.id] {
            } else {
                let getAnnounceResult = await announceGet.getAnnouncesFiltered(text: nil, priceStart: 0, priceEnd: 10000, category: nil, startDate: nil, myAnnounceOnly: false, announceID: chat.announceID)
                switch getAnnounceResult {
                case .success(let success):
                   
                    
                    self.announceForChat[chat.id] = success[0]
                    
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func getUnredMessagesForChat(chat: Chat)-> Int  {        
        messageGet.getUnredMessagesForChat(chat: chat)
    }
    
}
