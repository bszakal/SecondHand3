//
//  MessagesView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//

import SwiftUI

struct MessagesView: View {
    
    @StateObject var messagesVM = MessagesVM()
    @State private var offset: CGFloat = 1000
    @State private var chatIDs = [String]()
    var body: some View {
        

            NavigationStack{
                ScrollView{
                    VStack(spacing:20){
                        ForEach(messagesVM.chats) {chat in
                            if let announce = messagesVM.announceForChat[chat.id],
                               let userProfile = messagesVM.userProfileForChat[chat.id] {
                                NavigationLink {
                                    ChatView(announceId: chat.announceID, otherUser: messagesVM.userProfileForChat[chat.id] ?? UserProfile(id: "", emailAddress: ""),user: messagesVM.currentUserProfile)
                                    
                                } label: {
                                    ZStack(alignment:.trailing){
                                        VStack(alignment:.leading){
                                            MessageAnnounceRowView(announce: announce, userProfile: userProfile, unreadMessageCount: messagesVM.getUnredMessagesForChat(chat: chat))
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .padding(.trailing)
                                            .foregroundColor(.primary)
                                    }
                                    .offset(y: self.chatIDs.contains(chat.id) ? 0 : offset )
                                    .animation(.linear(duration: 0.5), value: self.chatIDs.contains(chat.id))
                                    .onAppear{
                                        withAnimation{
                                            self.chatIDs.append(chat.id)
                                        }
                                    }
                                }                                
                                .listRowSeparator(.hidden)
                            }
                            
                        }
                    }
                    .padding()
                }
                .listStyle(.plain)
                .navigationTitle("Messages")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.gray, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MessagesView()
        }
            
    }
}
