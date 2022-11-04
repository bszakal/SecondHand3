//
//  SignInWithCorrectProviderView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 31/10/22.
//

import SwiftUI

struct SignInWithCorrectProviderView: View {
    
    @EnvironmentObject var logInState: LoginState
    @Environment(\.dismiss) var dismiss
    @StateObject var signInCorrectProviderVM = SignInWithCorrectProvider()
    var correctProvider: LoginVM.CorrectProvider
    
    var body: some View {
        
        VStack{
            titleViewCorrectProvider
                .padding(.bottom)
            Text("Looks like you already have an account, login with the method below instead")
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            switch correctProvider {
            case .facebook:
                Button {
                    signInCorrectProviderVM.SignInFacebook()
                } label: {
                    ZStack(alignment: .leading){
                        Text("Continue with Facebook")
                            .modifier(logingButtonModif())
                        Image("Facebook")
                            .mylogoModifier()
                    }
                }
            case .Google:
                Button {
                    signInCorrectProviderVM.SignInGoogle()
                } label: {
                    ZStack(alignment: .leading){
                        Text("Continue with Google")
                            .modifier(logingButtonModif())
                        Image("Google")
                            .mylogoModifier()
                    }
                    
                }
            case .Email:
                Text("")
            }
            
           Text(signInCorrectProviderVM.errorDisplayMessage)
                .foregroundColor(.red)
            
            Spacer()
            
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        
        .onChange(of: logInState.isLoggedIn) { newValue in
            if newValue == true { dismiss() }
        }
    }
    
    
    
    
    var titleViewCorrectProvider: some View {
        
            VStack{
                ZStack{
                    Text("Account exists")
                        .fontWeight(.bold)
                    HStack{
                        Image(systemName: "xmark")
                            .padding(.leading)
                            .onTapGesture {
                                dismiss()
                            }
                        Spacer()
                    }
                }
                .font(.title2)
                .padding(.top, 20)
                dividerCustom
                
            }
    }
}



struct SignInWithCorrectProviderView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithCorrectProviderView(correctProvider: LoginVM.CorrectProvider.Google)
            .environmentObject(LoginState())
    }
}
