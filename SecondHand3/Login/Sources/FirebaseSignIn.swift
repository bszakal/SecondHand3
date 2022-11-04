//
//  FirebaseSignIn.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 29/10/22.
//
import Firebase
import Foundation

enum SignInError: Error {
    case emailNotVerified
    case emailAlreadyExists (String)
    case userNotSignedIn
    case otherError(error: Error)
    
}



protocol FireBaseSignInProtocol {
    
    func signInFirebase(credential: AuthCredential, CompletionHandler: @escaping (Result<Bool, SignInError>)->Void)
    func signInEmail(email: String, password: String) async -> Result<Bool, SignInError>
    func RegisterWithEmail(email: String, password: String) async -> Result<String, SignInError>
    func resetPassword(email: String) async -> Result<String, Error>
    func signOut() -> Result<Bool, Error>
    func isUserLoggedIn() -> Bool
    func getProvider() -> Result<String, SignInError>
    func getProviderForEmailAsync(email: String) async -> Result<String, Error>
    
}

class FireBaseSignIn: FireBaseSignInProtocol {
    
    
    func signInFirebase(credential: AuthCredential, CompletionHandler: @escaping (Result<Bool, SignInError>)->Void) {
        
        Auth.auth().signIn(with: credential) {(_, error) in
            if error != nil, let error = error as NSError? {
                let authErrorCode = AuthErrorCode(_nsError: error)
                let code = authErrorCode.code
                switch code {
                case .accountExistsWithDifferentCredential : return CompletionHandler(.failure(SignInError.emailAlreadyExists(error.userInfo["FIRAuthErrorUserInfoEmailKey"] as! String)))
                default: return CompletionHandler(.failure(.otherError(error: error)))
                }
              
          } else {
              CompletionHandler(.success(true))
            
          }
        }
        
    }
    
    func signInEmail(email: String, password: String) async -> Result<Bool, SignInError> {
        
        do {
            let authResult =  try await Auth.auth().signIn(withEmail: email, password: password)
            if authResult.user.isEmailVerified {
                return .success(true)
            } else {
                return.failure(.emailNotVerified)
            }
        } catch {
            if let error = error as NSError? {
                let authErrorCode = AuthErrorCode(_nsError: error)
                switch authErrorCode.code {
                case .emailAlreadyInUse:
                    return .failure(SignInError.emailAlreadyExists(error.userInfo["FIRAuthErrorUserInfoEmailKey"] as! String))
                default: return .failure(.otherError(error: error))
                }

          }
        }
        
    }
    
    func RegisterWithEmail(email: String, password: String) async -> Result<String, SignInError> {
        
        do {
            let authResult =  try await Auth.auth().createUser(withEmail: email, password: password)
            try await authResult.user.sendEmailVerification()
            return .success("A verification email has been sent, please check your inbox")
        } catch {
            if let error = error as NSError? {
                let authErrorCode = AuthErrorCode(_nsError: error)
                switch authErrorCode.code {
                case .emailAlreadyInUse:
                    return .failure(SignInError.emailAlreadyExists(error.userInfo["FIRAuthErrorUserInfoEmailKey"] as? String ?? "Email is already registered, please sign in"))
                default: return .failure(.otherError(error: error))
                }

          }
        }
        
    }
    
    func resetPassword(email: String) async -> Result<String, Error> {
        
        do{
           try await Auth.auth().sendPasswordReset(withEmail: email)
            return .success("An email with a link to reset your password has been sent")
        } catch{
            return .failure(error)
        }
    }
    
    func signOut() -> Result<Bool, Error> {
        
        do {
          try Auth.auth().signOut()
            return .success(true)
        } catch {
            return .failure(error)
        }

    }
    
    func isUserLoggedIn() -> Bool {
        
            if let user = Auth.auth().currentUser {
                if user.isEmailVerified {
                    return true
                }
                return false
            }
        return false
    }
    
    func getProvider() -> Result<String, SignInError> {
        if let providerid = Auth.auth().currentUser?.providerData[0].providerID {
                 switch providerid {
                 case "facebook.com":
                     return .success("Facebook")
                 case "google.com":
                     return .success("Google")
                 default:
                     return .success("Other")
                 }
             
         }
        return .failure(.userNotSignedIn)
    }
    
    
    func getProviderForEmailAsync(email: String) async -> Result<String, Error> {
        do{
            let (providers) = try await Auth.auth().fetchSignInMethods(forEmail: email)
            return .success(providers[0])
        }
        catch {
            return .failure(error)
        }
        
        
    }
    
}
