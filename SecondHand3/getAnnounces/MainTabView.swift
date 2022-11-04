//
//  MainTabView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//

import SwiftUI

struct MainTabView: View {
    

    var body: some View {
        TabView{
               
            HomePageView()
                .tabItem {
                    Label("Announces", systemImage: "list.bullet.rectangle.fill")
                }
                .tag(0)
            Text("Favourite")
                .tabItem {
                    Label("Favourites", systemImage: "music.note.list")
                }
                .tag(1)
        }
    }
    
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
