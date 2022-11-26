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
                            itemListViewMyAccount(imageName: "person.crop.circle.fill",
                                                  text: "Edit profile")
                        }
                    } header: {
                        Text("Profile")
                    }
                    .listSectionSeparator(.hidden)
                    //
                    
                    Section{
                        NavigationLink {
                            FavouriteView()
                        } label: {
                            itemListViewMyAccount(imageName: "heart.fill", text: "Favourites")
                        }
                        .listSectionSeparator(.hidden)
                        
                        NavigationLink {
                            MyAnnouncesView()
                        } label: {
                            itemListViewMyAccount(imageName: "list.bullet.rectangle.fill",
                                                  text: "My announces")
                        }
                        .listSectionSeparator(.hidden)
                        
                    } header: {
                        Text("Announces")
                    }
                    .listSectionSeparator(.hidden)
                    //
        
                    Button("Log out") { myAccountVM.logOut() }
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
struct itemListViewMyAccount: View {
    let imageName: String
    let text: String
    var body: some View{
        HStack{
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(.primary)
            Text(text)
        }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
