//
//  LoginVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 31/10/22.
//

import SwiftUI

@MainActor class LoginVM: ObservableObject {
    
     enum CorrectProvider: String, Identifiable {
        case facebook
        case Google
        case Email
        var id: String { return self.rawValue }
    }
    
    @Inject var logger: loggerProtocol
    
    @Published var correctProvider: CorrectProvider?
    @Published private(set) var emailSignInErrornotification = ""
    
    func SignInFacebook() {
        logger.SignInFederated(provider: Logger.FederatedProvider.Facebook) { email, provider, err in
            if let provider = provider {
                if provider == "google.com" {
                    self.correctProvider = .Google
                } else if provider == "facebook.com" {
                    self.correctProvider = .facebook
                }
            }
        } 
    }
    
    func SignInGoogle() {
        logger.SignInFederated(provider: Logger.FederatedProvider.Google) { email, provider, err in
            if let provider = provider {
                if provider == "google.com" {
                    self.correctProvider = .Google
                } else if provider == "facebook.com" {
                    self.correctProvider = .facebook
                }
            }
        }
    }
    
    func signInWithEmail(email: String, password: String) async {
        Task {
            let result = await self.logger.signInWithEmail(email: email,  password: password)
            switch result {
            case .success(_):
                return
            case .failure(let fail):
                switch fail {
                case SignInError.emailAlreadyExists:
                    self.emailSignInErrornotification = "Email already exists please sign in"
                default:
                    self.emailSignInErrornotification = "Ooops Error, wrong email or password"
                }
                
            }
        }
    }
    

}

