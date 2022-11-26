//
//  FederatedSignInView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 24/11/22.
//

import SwiftUI

struct FederatedSignInView: View {
    @ObservedObject var loginVM: LoginVM
    var body: some View {
        VStack{
            Button {
                loginVM.SignInGoogle()
            } label: {
                ZStack(alignment: .leading){
                    Text("Continue with Google")
                        .modifier(logingButtonModif())
                    Image("Google")
                        .mylogoModifier()
                }
            }
            
            Button {
                loginVM.SignInFacebook()
            } label: {
                ZStack(alignment: .leading){
                    Text("Continue with Facebook")
                        .modifier(logingButtonModif())
                    Image("Facebook")
                        .mylogoModifier()
                }
            }
        }
        .foregroundColor(.primary)
    }
}

struct FederatedSignInView_Previews: PreviewProvider {
    static var previews: some View {
        FederatedSignInView(loginVM: LoginVM())
    }
}
