//
//  ContentView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 29/10/22.
//

import SwiftUI



struct LoginView: View {
    
    @EnvironmentObject var loginState: LoginState
    @Environment(\.dismiss) var dismiss
    @StateObject var loginVM = LoginVM()
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    @State private var showRegisterView = false
   
    var body: some View {
        
        ZStack{
            
            titleView
            
            VStack(alignment:.leading){
                EmailSignInView(loginVM: loginVM)
                emailRegisterButton
                
                dividerBtwnEmailAndFederated
                
                FederatedSignInView(loginVM: loginVM)
                
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(.keyboard, edges:.bottom)
        
        .sheet(item: $loginVM.correctProvider) { provider in
            SignInWithCorrectProviderView(correctProvider: provider)
                .presentationDetents([.medium])
        }
        
        .sheet(isPresented: $showRegisterView) {
            RegisterEmailView()
        }
        
        .onChange(of: loginState.isLoggedIn) { newValue in
            if newValue == true { dismiss() }
        }
        
    }
    
    var titleView: some View {
        
        VStack{
            ZStack{
                Text("Log in or Sign up")
                    .fontWeight(.bold)
                
                HStack{
                    Image(systemName: "xmark")
                        .padding(.leading)
                        .onTapGesture { dismiss() }
                    Spacer()
                }
            }
            .font(.title2)
            .padding(.top, 20)
            dividerCustom
            Spacer()
        }      
    }
    
    var dividerBtwnEmailAndFederated: some View {
        HStack{
            dividerCustom
            Text("or")
                .font(.headline)
            dividerCustom
        }
        .padding(.bottom, 50)
    }
    
    var emailRegisterButton: some View {
        Button(action: {
            showRegisterView = true
        }, label: {
            Text("Register")
                .fontWeight(.bold)
                .underline()
                .padding(.leading, 5)
                .padding(.top, 5)
                .foregroundColor(.primary)
        })
            .padding(.bottom, 10)
    }
}



var dividerCustom: some View {
    Rectangle()
        .frame(maxHeight: 1)
        .opacity(0.3)
}

struct logingButtonModif: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(RoundedRectangle(cornerRadius: 10).stroke())
    }
}

struct Email_Password: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(RoundedRectangle(cornerRadius: 10).stroke())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginState())
            
    }
}

extension Image {
    func mylogoModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .padding()
   }
}

