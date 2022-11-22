//
//  TestView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 31/10/22.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var loginState: LoginState
    @Inject var logger: loggerProtocol
    @State private var showLoginView = false
    var body: some View {

        MainTabView()

//        if loginState.isLoggedIn {
//            MainTabView()
//            //listOfCategoriesView()
//            //AnnounceView()
//            //CreateAnnounceStartView()
//            //FavouriteView()
//            //MyAccountView()
////            NavigationStack{
////                UserProfileView()
////            }
//            //MessagesView()
//        } else {
//            //LoginView()
//        }
    }
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(LoginState())
    }
}
