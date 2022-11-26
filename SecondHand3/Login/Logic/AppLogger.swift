//
//  AppLogger.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 29/10/22.
//
import Combine
import Firebase
import Foundation



protocol loggerProtocol {
    
    
    var IsSignedInPublished: Published<Bool>.Publisher{get}
    func SignInFederated(provider: Logger.FederatedProvider, CompletionHandler: @escaping (String?, String?, Error?)->Void)
    func getLoginState() -> Bool
    func logOut()
    
    func signInWithEmail(email: String, password: String) async -> Result<Bool, Error>
    func registerWithEmail(email: String, password: String) async -> Result<String, Error>
}


class Logger: loggerProtocol {
    
    @Published private(set) var isSignedIn = false
    var IsSignedInPublished: Published<Bool>.Publisher{ $isSignedIn}
    
    
    enum FederatedProvider {
        case Facebook
        case Google
    }
    
    @Inject private var googleSignin: GoogleSignInProtocol
    @Inject private var facebookSignin: FacebookSignInProtocol
    @Inject private var firebasesignin: FireBaseSignInProtocol
    
    init() {
        self.isSignedIn = firebasesignin.isUserLoggedIn()
    }
    
    func SignInFederated(provider: Logger.FederatedProvider, CompletionHandler: @escaping (String?, String?, Error?)->Void) {
        
        switch provider {
        case .Google:
            googleSignin.signIn { cred in
                if let cred = cred {
                    self.SignInFederatedFirebase(credential: cred) { email, provider, err in
                        CompletionHandler(email, provider, err)
                    }
                }
            }
        case .Facebook:
            facebookSignin.signIn { cred in
                if let cred = cred {
                    self.SignInFederatedFirebase(credential: cred) { email, provider, err in
                        CompletionHandler(email, provider, err)
                    }
                }
            }
        }
    }
    private func SignInFederatedFirebase(credential: AuthCredential, CompletionHandler: @escaping (String?, String?, Error?)->Void) {
       
            
        firebasesignin.signInFirebase(credential: credential) { res in
            DispatchQueue.main.async {
                switch res {
                case .success(let success):
                    self.isSignedIn = success
                    CompletionHandler(nil, nil, nil)
                case .failure(let failure):
                    switch failure {
                    case .emailAlreadyExists (let email) :
                        Task{
                            let res = await  self.firebasesignin.getProviderForEmailAsync(email: email)
                            switch res {
                            case .success(let success):
                                CompletionHandler(email, success, nil)
                            case .failure(let failure):
                                CompletionHandler(email, nil, failure)
                            }
                        }
                    default:
                        CompletionHandler(nil, nil, failure)
                    }
                }
            }
        }
    }
    
    
  @MainActor  func signInWithEmail(email: String, password: String) async -> Result<Bool, Error> {
        
        let result = await firebasesignin.signInEmail(email: email, password: password)
        switch result {
        case .success(let success):
            self.isSignedIn = success
            return .success(success)
        case .failure(let failure):
            switch failure {
            case .emailAlreadyExists :
                return .failure(SignInError.emailAlreadyExists(""))
            default: return .failure(failure)
            }
        }
    }
    
    @MainActor  func registerWithEmail(email: String, password: String) async -> Result<String, Error> {
          
          let result = await firebasesignin.RegisterWithEmail(email: email, password: password)
          switch result {
          case .success(let success):
              return .success(success)
          case .failure(let failure):
              switch failure {
              case .emailAlreadyExists (_):
                  return .failure(SignInError.emailAlreadyExists(""))
              default: return .failure(failure)
              }
          }
      }
    
    func getLoginState() -> Bool {
        firebasesignin.isUserLoggedIn()
    }
    
   @MainActor func logOut() {
        let result = firebasesignin.getProvider()
        switch result {
        case .success(let success):
            if success == "Facebook" {
                facebookSignin.signOut()
            } else if success == "Google" {
                googleSignin.signOut()
            }
            
            let firebaseSignOutRes = firebasesignin.signOut()
            switch firebaseSignOutRes {
            case .success(_):
                self.isSignedIn = false
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}
