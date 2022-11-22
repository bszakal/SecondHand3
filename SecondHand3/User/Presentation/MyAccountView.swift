//
//  MyAccountView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//

import SwiftUI

struct MyAccountView: View {

    @StateObject var myAccountVM = MyAccountVM()
    var body: some View {
        
            NavigationStack{
                List{
                    Section {
                        NavigationLink {
                            UserProfileView()
                        } label: {
                            HStack{
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Text("Edit profile")
                            }
                        }
                        
                    } header: {
                        Text("Profile")
                        
                    }
                    .listSectionSeparator(.hidden)
                    
                    Section{
                        NavigationLink {
                            FavouriteView()
                        } label: {
                            HStack{
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Text("Favourites")
                            }
                        }
                        .listSectionSeparator(.hidden)
                        
                        NavigationLink {
                            MyAnnouncesView()
                        } label: {
                            HStack{
                                Image(systemName: "list.bullet.rectangle.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Text("My announces")
                            }
                        }
                        .listSectionSeparator(.hidden)
                        
                    } header: {
                        Text("Announces")
                    }
                    .listSectionSeparator(.hidden)
                    
                    
                    Button("Log out") {
                        myAccountVM.logOut()
                    }
                    .listSectionSeparator(.hidden)
                    .underline()
                    .fontWeight(.semibold)
                    
                }
                .listStyle(.plain)
                .navigationTitle("My Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.gray, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
