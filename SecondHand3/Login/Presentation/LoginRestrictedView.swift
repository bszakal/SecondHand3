//
//  LoginRestrictedView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 21/11/22.
//

import SwiftUI

struct LoginRestrictedView: View {
    
    @State private var showLoginPage = false
    
    let title: String
    var body: some View {
        VStack(alignment:.leading, spacing: 30){
            HStack{
                Text(title)
                Spacer()
            }
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.horizontal, 25)
            
            Text("Log in to see \(title)")
                .font(.title)
                .padding(.horizontal, 25)
            
            Button {
                showLoginPage = true
            } label: {
                Text("Log in")
                    .modifier(buttonModifierCreateAnnouce())
                    .fontWeight(.bold)
                    .font(.title)
            }

                Spacer()
        }
        .padding(.top, 70)
        
        .sheet(isPresented: $showLoginPage) {
            LoginView()
        }
    }
}

struct LoginRestrictedView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRestrictedView(title: "Publish")
    }
}
