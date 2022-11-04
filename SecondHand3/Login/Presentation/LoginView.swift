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
                
                emailSignIn
                emailLoginButton
               
                HStack{
                    dividerCustom
                    Text("or")
                        .font(.headline)
                    dividerCustom
                }
                .padding(.bottom, 50)
                
                loginButtons
                
            }
            .padding(.horizontal)
        }
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
                            .onTapGesture {
                                dismiss()
                            }
                            
                        Spacer()
                    }
                }
                .font(.title2)
                .padding(.top, 20)
                dividerCustom
                Spacer()
            }
         
        
    }
    
    var emailLoginButton: some View {
        Button(action: {
            showRegisterView = true
        }, label: {
            Text("Register")
                .padding(.leading, 5)
        })
            .padding(.bottom, 10)
    }
    
        
    var loginButtons: some View {
        
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
        
    
    
    
 @ViewBuilder  var emailSignIn: some View {
     VStack(spacing: 5){
         
         Text(loginVM.emailSignInErrornotification)
             .foregroundColor(.red)
             .padding(.bottom)
         
         TextField("Email", text: $email)
             .modifier(Email_Password())
             .textInputAutocapitalization(.never)
             .autocorrectionDisabled(true)
             
         ZStack(alignment:.trailing){
             Group{
                 if showPassword {
                     TextField("Password", text: $password)
                     
                 } else {
                     SecureField("Password", text: $password)
                 }
             }
             
             .modifier(Email_Password())
             Group{
                 if showPassword {
                     Image(systemName: "eye.slash")
                         .onTapGesture {
                             showPassword.toggle()
                         }
                 } else {
                     Image(systemName: "eye.circle")
                         .onTapGesture {
                             showPassword.toggle()
                         }
                 }
             }
             .padding(.trailing)
             
         }
     }

     .padding(.bottom, 20)
     
     Button {
         Task {
             await loginVM.signInWithEmail(email:self.email, password: self.password)
         }
     } label: {
         Text("Continue")
             .foregroundColor(.white)
             .font(.title2)
             .fontWeight(.semibold)
             .frame(maxWidth: .infinity, maxHeight: 60)
             .background(.pink.opacity(0.8))
             .clipShape((RoundedRectangle(cornerRadius: 10)))
     }
     .disabled(email.count < 5 || password.count < 5)

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

