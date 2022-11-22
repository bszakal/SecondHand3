//
//  AnnounceDetailedView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 11/11/22.
//

import SwiftUI

struct AnnounceDetailedView: View {
    
    @EnvironmentObject var loginState: LoginState
    @State private var showloginView = false
    
    @StateObject var announceDetailedVM = AnnounceDetailedVM()
    let announce: Announce
    
    @State private var scaleEffectFav: Double = 1
    @State private var changedFavourite: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                ScrollView{
                    VStack{
                        photoDetailedView
                            .frame(height: geo.frame(in: .local).height / 2)
                        VStack(alignment:.leading){
                            announceMainInfos
                            
                            userDetails
                            
                            announceDescription
                            
                            announceCondition
                            
                            announceDelivery
                            
                        }
                        .padding(.horizontal)
                    }
                }
               
                bottomBar
              
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(content: {
            favouriteButton
        })
        .edgesIgnoringSafeArea(.top)
        .onAppear{
            announceDetailedVM.isAFavourite(announce: announce)
            announceDetailedVM.getUserDetailsForAnnounce(announce: announce)
            announceDetailedVM.getCurrentUserDetails()
            
        }
        .sheet(isPresented: $showloginView) {
            LoginView()
        }
    }
    
    var photoDetailedView: some View {
                photoView2(imageUrlsString: announce.imageRefs)
    }
    
    var userDetails: some View {
        VStack(alignment:.leading){
            HStack{
                photoView2(imageUrlsString: [announceDetailedVM.userProfileForAnnounce.profilePictureUrlStr])
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                VStack(alignment:.leading){
                    Text(announceDetailedVM.userProfileForAnnounce.pseudo)
                        .font(.title3)
                        .padding(.bottom, 10)
                    HStack{
                        ForEach(1...5, id:\.self){nbre in
                            Image(systemName: "star.fill")
                        }
                    }
                }
            }
            HStack{
                Spacer()
                dividerCustom
                    .frame(width: 75)
                Spacer()
            }
        }
    }
    
    var announceMainInfos: some View {
        VStack{
            HStack{
                VStack(alignment:.leading){
                    Text(announce.title)
                    // .padding(.bottom, 1)
                    Text((announce.price), format: .currency(code: "EUR"))
                        .padding(.bottom, 1)
                    Text(announce.lastUpdatedAt ?? Date(), format: .dateTime)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                    
                }
                .font(.title3)
                .fontWeight(.semibold)
                Spacer()
            }
            HStack{
                Spacer()
                dividerCustom
                    .frame(width: 75)
                Spacer()
            }
        }
    }
    
    var announceDescription: some View {
        VStack(alignment:.leading){
            Text("Description")
                .font(.title3)
                .fontWeight(.semibold)
               // .padding(.bottom,1)
                .foregroundColor(.secondary)
            Text(announce.description)
            //dividerCustom
        }
        .padding(.bottom)
    }
    
    var announceCondition: some View {
        VStack(alignment:.leading){
            Text("Condition")
                .font(.title3)
                .fontWeight(.semibold)
                //.padding(.bottom,1)
                .foregroundColor(.secondary)
            Text(announce.condition)
            
            //dividerCustom
        }
        .padding(.bottom)
    }
    
    var announceDelivery: some View {
        VStack(alignment:.leading){
            Text("Delivery")
                .font(.title3)
                .fontWeight(.semibold)
               // .padding(.bottom,1)
                .foregroundColor(.secondary)
            Text(announce.deliveryType)
        }
    }
    
    var bottomBar: some View {
        VStack{
            dividerCustom
                .scaleEffect(3)
                .padding(.bottom, 5)
            HStack{
   
                NavigationLink {
                    if loginState.isLoggedIn{
                        ChatView(announceId: announce.id ?? "", otherUser: announceDetailedVM.userProfileForAnnounce, user: announceDetailedVM.currentUserProfile)
                    } else {
                        LoginView().navigationBarBackButtonHidden()
                    }
                } label: {
                    ZStack{
                        Text("Message")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                        RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.primary)
                    }
                }
                
                
                Button {
                    
                } label: {
                    ZStack{
                        Text("Buy")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                           
                        RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.primary)
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(.horizontal)
            
        }
        .background(.white)
    }
    
    var favouriteButton: some View {
        Button {
            if loginState.isLoggedIn{
                if announceDetailedVM.isAFavourite {
                    announceDetailedVM.removeFromFavourite(announce: announce)
                } else {
                    announceDetailedVM.addToFavourite(announce: announce)
                }
                Task{
                    scaleEffectFav = 2
                    try await Task.sleep(nanoseconds: 200_000_00)
                    scaleEffectFav = 1
                }
            } else {
                showloginView = true
            }
        } label: {
            if announceDetailedVM.isAFavourite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(6)
                    .background(Circle().foregroundColor(.white))
                    .modifier(animatedFavChange(scaleEffectFav: scaleEffectFav))
            } else {
                Image(systemName: "heart")
                    .foregroundColor(.primary)
                    .padding(6)
                    .background(Circle().foregroundColor(.white))
                    .modifier(animatedFavChange(scaleEffectFav: scaleEffectFav))
                    
            }
        }

    }
}

struct AnnounceDetailedView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack{
            AnnounceDetailedView(announce: Announce.example)
                .environmentObject(LoginState())
        }
    }
}
