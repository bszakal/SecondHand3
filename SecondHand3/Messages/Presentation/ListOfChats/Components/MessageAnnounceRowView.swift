//
//  MessageAnnounceRowView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 14/11/22.
//

import SwiftUI

struct MessageAnnounceRowView: View {
 
    let announce: Announce
    let userProfile: UserProfile
    var unreadMessageCount = 0
    
    var body: some View {
        
            ZStack(alignment:.topTrailing){
                HStack{
                    photoView2(imageUrlsString: [userProfile.profilePictureUrlStr])
                        .frame(width: 80, height:80)
                        .clipShape(Circle())
                    
                    textView
                        .frame(height: 100)
                    Spacer()
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                
                unreadMessCounter
                    .padding(10)
            }
           
        
    }
    
    var textView: some View {

        VStack(alignment:.leading){
            
                Text(userProfile.pseudo)
                    .font(.title3)
                    .foregroundColor(.primary)
                Text(announce.title)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
        .padding(.vertical)
        
    }
    
   @ViewBuilder var unreadMessCounter: some View {
        if unreadMessageCount != 0{
            Text(unreadMessageCount, format: .number)
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding(5)
                .background(.black)
                .clipShape(Circle())
                .padding(.horizontal, 5)
                .animation(.default, value: unreadMessageCount)
            
        }
    }
}

struct MessageAnnounceRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageAnnounceRowView(announce: Announce.example, userProfile: UserProfile.example)
    }
}
