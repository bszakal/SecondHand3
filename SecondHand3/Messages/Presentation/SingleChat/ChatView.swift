//
//  ChatView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 14/11/22.
//

import SwiftUI

struct ChatView: View {
    

    let otherUser: UserProfile
    let user: UserProfile
    @StateObject var chatVM: ChatVM
    @State private var id = ""
    @State private var newMessage = ""
    

    init(announceId: String, otherUser: UserProfile, user: UserProfile) {
  
        self.otherUser = otherUser
        self.user = user
        self._chatVM = StateObject(wrappedValue: ChatVM(announceId: announceId, announceUserId: otherUser.id))
    }
    
    var idMostRecent: String {
        if let MostRecentMessage = chatVM.chat.messages.sorted().last {
            return MostRecentMessage.id!
        } else {
            return ""
        }
    }
    
   

    var body: some View {
        
        VStack{
            if chatVM.isChatLoaded{
                ScrollViewReader{ proxy in
                    ScrollView{
                        
                        ForEach(chatVM.dates.sorted(), id:\.self){ date in
                            Section {
                                ForEach(chatVM.chat.messages.filter{chatVM.areDatesSameDay(dateGroup: date, dateMessage: $0.createdAt ?? Date())}) { mess in
                                    
                                    HStack{
                                        messageRowView(mess: mess, otherUser: otherUser, user: user)
                                        Spacer()
                                    }
                                    .padding(.bottom)
                                    .padding(.horizontal)
                                    
                                    .id(mess.id)
                                    .onAppear{
                                        chatVM.amendMessagesToRead(messages:[mess])
                                        self.id = mess.id ?? ""
                                    }
                                }
                                .listRowSeparator(.hidden)
                            } header: {
                                headerDate(date: date)
                            }
                            
                        }
                        
                    }
                    .onAppear{
                        proxy.scrollTo(idMostRecent, anchor: .bottom)
                    }
                    .onChange(of: self.id, perform: { newValue in
                        if newValue == idMostRecent{
                            proxy.scrollTo(self.id, anchor: .bottom)
                        }
                        
                        
                    })
                    .listStyle(.plain)
                }
            } else {
                Spacer()
            }
            
            writeNewMessage
        }
        .onAppear{
            chatVM.suscribeChatLiveData()
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            HStack{
                photoView2(imageUrlsString: [otherUser.profilePictureUrlStr])
                    .frame(width:45, height:45)
                    .clipShape(Circle())
                VStack(alignment:.leading){
                    Text(otherUser.pseudo)
                        .fontWeight(.bold)
                    HStack(alignment:.bottom, spacing:0){
                        Image(systemName: "star.fill")
                        Text("5")
                    }
                }
                
            }
        }
    }
    
    
    struct messageRowView: View {
        let mess: Message
        let otherUser: UserProfile
        let user: UserProfile
        var body: some View{
           
                VStack(alignment:.leading, spacing:5){
                    HStack{
                        if mess.senderID == otherUser.id {
                            Text(otherUser.pseudo)
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            
                        } else {
                            Text(user.pseudo)
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        }
                        Text(mess.createdAt ?? Date(), format: .dateTime.hour().minute())
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(mess.messageContent)
                        .font(.system(.subheadline, design: .rounded))
                    
                }
            }
    }
    
    var writeNewMessage: some View {
        VStack{
            Spacer()
            ZStack(alignment:.trailing){
                TextField("Write a message", text: $newMessage)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 30).stroke().foregroundColor(.secondary))
                
                if newMessage != ""{
                    Image(systemName: "arrow.up.circle")
                        .padding(.horizontal)
                        .font(.title)
                        .foregroundColor(.secondary)
                        .onTapGesture{
                            chatVM.sendMessage(content: newMessage)
                            newMessage = ""
                        }
                }
            }
        }
        .frame(height:50)
        .padding(.horizontal)
    }
    
    struct headerDate: View {
        let date: Date
        var body: some View{
            HStack{
                Spacer()
                Text(date, format:.dateTime.day().month())
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.bottom)
        }
    }

    
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ChatView(announceId:Announce.example.id ?? "", otherUser: UserProfile.example, user: UserProfile.example)
        }
    }
}
