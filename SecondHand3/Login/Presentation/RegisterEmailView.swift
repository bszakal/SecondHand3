//
//  RegisterEmailView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 31/10/22.
//

import SwiftUI

struct RegisterEmailView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var loginState: LoginState
    @StateObject var registerEmailVM = RegisterEmailVM()
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    
    var body: some View {
        ZStack{
            VStack {
                titleViewRegister
                Spacer()
            }
            VStack{
                
                emailSignIn
                    .padding(.bottom, 20)
                Text(registerEmailVM.notification)
            }
            .padding()
        }
    }
    
    var titleViewRegister: some View {
        
            VStack{
                ZStack{
                    Text("Email registration")
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
    
    @ViewBuilder  var emailSignIn: some View {
        VStack{
            VStack(spacing: 5){
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
                registerEmailVM.registerEmail(email:self.email, password: self.password)
                
            } label: {
                Text("Register")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.black.opacity(0.7))
                    .clipShape((RoundedRectangle(cornerRadius: 10)))
            }
            .disabled(email.count < 5 || password.count < 5)
            
        }
    }
}

struct RegisterEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterEmailView()
            .environmentObject(LoginVM())
    }
}
