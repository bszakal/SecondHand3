//
//  RegisterEmailVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 31/10/22.
//

import SwiftUI
@MainActor
class RegisterEmailVM: ObservableObject {
    
    @Inject var logger: loggerProtocol
    
    @Published private(set) var notification = ""
    
    
    func registerEmail(email: String, password: String) {
        
        Task {
            let result = await self.logger.registerWithEmail(email: email,  password: password)
            switch result {
            case .success(let success):
                self.notification = success
            case .failure(let fail):
                switch fail {
                case SignInError.emailAlreadyExists:
                    self.notification = "Email already exists please sign in"
                default:
                    self.notification = "Ooops Error, please check if it is a valid email"
                }
                
            }
        }
        
        
    }
    
}
