import Firebase
import Foundation
import GoogleSignIn


protocol GoogleSignInProtocol {
    func signIn(CompletionHandler: @escaping (AuthCredential?)->Void)
    func signOut()
}

class GoogleSignIn: GoogleSignInProtocol {
    
    
    func signIn(CompletionHandler: @escaping (AuthCredential?)->Void) {
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn {user, error in
                
                guard let authentication = user?.authentication, let idToken = authentication.idToken else { return}
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                
                CompletionHandler(credential)
                return
            }
        } else {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else {return}
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return}
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return}
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) {user, error in
                guard let authentication = user?.authentication, let idToken = authentication.idToken else { return}
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                
                CompletionHandler(credential)
                return
                
            }
            
        }
    }
    
    func signOut() {
        
        GIDSignIn.sharedInstance.signOut()
    }
    
}
