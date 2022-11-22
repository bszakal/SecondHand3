//
//  FirebaseUserProfile.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//
import FirebaseStorage
import Firebase
import FirebaseFirestore
import Foundation

protocol FirebaseUserProfileProtocol {
    
    func getUserProfile(userUID: String) async -> Result<UserProfile, Error>
    func getuserUID() async ->Result<String, Error>
    func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error>
    func getuserEmailAddress() async ->Result<String, Error>
    func DeleteUserProfile(user: UserProfile) async -> Error?
    func addUserProfile(user: UserProfile)
}

class FirebaseUserProfile: FirebaseUserProfileProtocol {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = Auth.auth().currentUser?.uid
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    func getuserEmailAddress() async ->Result<String, Error> {
        
        let userUID = Auth.auth().currentUser?.email
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    
    func getUserProfile(userUID: String) async -> Result<UserProfile, Error> {
        
        let db = Firestore.firestore()
        let docRef = db.collection("UserProfiles").document(userUID)
            
        do{
            
            let querySnapshots = try await docRef.getDocument()
            let userProfile = try querySnapshots.data(as: UserProfile.self)
            
            return .success(userProfile)
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
        
    }
    
    func DeleteUserProfile(user: UserProfile) async -> Error?{
        let db = Firestore.firestore()
        let docRef = db.collection("UserProfiles").document(user.id)
        
        do{
           try await docRef.delete()
            return nil
        } catch {
            print(error.localizedDescription)
            return error
        }
    }
    
    func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error> {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let collection = storageRef.child("imagesProfiles")
        
        var urls = [String]()
        
        for photo in photosData {
            
            let photoref = collection.child(UUID().uuidString + ".jpeg")
            
            do{
                let _ = try await photoref.putDataAsync(photo)
                let url = try await photoref.downloadURL()
                let urlStr = url.absoluteString
                urls.append(urlStr)
                
            } catch{
                print(error.localizedDescription)
                return .failure(error)
                
            }
        }
            return .success(urls)
        
    }
    
    func addUserProfile(user: UserProfile) {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection("UserProfiles")
        let docRef = collection.document(user.id)
        
        do{
            try docRef.setData(from: user) {err in
                if let err1 = err {
                    print(err1.localizedDescription)
                }
            }
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    
}
