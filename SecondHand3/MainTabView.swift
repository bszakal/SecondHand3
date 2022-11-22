//
//  MainTabView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var loginState:LoginState
    @State private var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection){
            HomePageView()
                .tabItem {
                    Label("Announces", systemImage: "list.bullet.rectangle.fill")
                        .background(.white)
                }
                .tag(0)
            //
            Group{
                if loginState.isLoggedIn {
                    FavouriteView()
                } else{
                    LoginRestrictedView(title: "Favourites")
                }
            }
            .tabItem {
                Label("Favourite", systemImage: "heart.fill")
                    .background(.white)
            }
            .tag(1)
            //
            Group{
                if loginState.isLoggedIn {
                    StartPageCreateAnnounce()
                } else{
                    LoginRestrictedView(title: "Publish")
                }
            }
            .tabItem {
                Label("Publish", systemImage: "plus.square.fill")
                    .background(.white)
            }
            .tag(2)
            //
            Group{
                if loginState.isLoggedIn{
                    MessagesView()
                } else {
                    LoginRestrictedView(title: "Messages")
                }
            }
            .tabItem {
                Label("Inbox", systemImage: "envelope")
                    .background(.white)
            }
            .tag(3)
            //
            Group{
                if loginState.isLoggedIn {
                    MyAccountView()
                } else {
                    LoginRestrictedView(title: "My Account")
                }
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle.fill")
                    .background(.white)
            }
            .tag(4)
        }
        
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
    }

    
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
