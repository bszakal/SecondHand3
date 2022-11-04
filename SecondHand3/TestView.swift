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
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .onAppear{
//                if loginState.isLoggedIn {
//                    AnnounceView()
//                } else {
//                    showLoginView = true
//                }
//            }
//        Button("SignOut") {
//            logger.logOut()
//        }
//            .sheet(isPresented: $showLoginView) {
//                LoginView()
//
//            }
        
        if loginState.isLoggedIn {
            MainTabView()
            //listOfCategoriesView()
            //AnnounceView()
        } else {
            LoginView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(LoginState())
    }
}
