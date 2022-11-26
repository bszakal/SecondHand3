//
//  EmailSignIn.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 24/11/22.
//

import SwiftUI

struct EmailSignInView: View {
    
    @ObservedObject var loginVM: LoginVM
    
    @State private var showPassword = false
    @State private var password: String = ""
    @State private var email: String = ""
    
    var body: some View {
        VStack{
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
                        if showPassword { TextField("Password", text: $password) }
                        else { SecureField("Password", text: $password) }
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .modifier(Email_Password())
                    
                    Image(systemName: showPassword ? "eye.slash" : "eye.circle")
                        .onTapGesture { showPassword.toggle() }
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
                    .background(.black.opacity(0.7))
                    .clipShape((RoundedRectangle(cornerRadius: 10)))
            }
            //.disabled(email.count < 5 || password.count < 5)
            
        }
    }
}

struct EmailSignInView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignInView(loginVM: LoginVM())
    }
}
