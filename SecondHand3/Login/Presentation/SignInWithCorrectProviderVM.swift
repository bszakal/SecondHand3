//
//  SignInWithCorrectProviderVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 31/10/22.
//

import SwiftUI

@MainActor class SignInWithCorrectProvider: ObservableObject {
    
    
    @Inject var logger: loggerProtocol
    @Published private(set) var errorDisplayMessage = ""
    
    func SignInFacebook() {
        logger.SignInFederated(provider: Logger.FederatedProvider.Facebook) { email, provider, err in
            if let _ = err {
                self.errorDisplayMessage = "Login Error please try again"
            }
        }
    }
    
    func SignInGoogle() {
        logger.SignInFederated(provider: Logger.FederatedProvider.Google) { email, provider, err in
            if let _ = err {
                self.errorDisplayMessage = "Login Error please try again"
            }
        }
    }
    
}
