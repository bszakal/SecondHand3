//
//  fbSignIn.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 29/10/22.
//

import SwiftUI
import Firebase
import FBSDKLoginKit

protocol FacebookSignInProtocol {
    func signIn(CompletionHandler: @escaping (AuthCredential?)->Void)
    func signOut()
}

class FacebookSign: FacebookSignInProtocol {
    
    private let manager = LoginManager()
    
    func signIn(CompletionHandler: @escaping (AuthCredential?)->Void) {
        manager.logIn(permissions: ["public_profile","email"], from: nil) {
            result, err in
                if let error = err {
                    print(error.localizedDescription)
                  return
                }
            
            guard let requestIsCancelled = result?.isCancelled, requestIsCancelled != true else {return}
         
            if let accessToken = AccessToken.current?.tokenString {
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                CompletionHandler(credential)
            }
        }
    }
    
    func signOut() {
        manager.logOut()
    }
    
}
