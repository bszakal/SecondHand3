//
//  CreateAnnounceFirebase.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 06/11/22.
//
import Firebase
import FirebaseStorage
import Foundation

protocol CreateAnnounceFirebaseProtocol {
    func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error>
    func getuserUID() async ->Result<String, Error>
    func addAnnounce(announce: Announce)
}


class CreateAnnounceFirebase: CreateAnnounceFirebaseProtocol {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error> {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let collection = storageRef.child("imagesAnnounces")
        
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
  
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = Auth.auth().currentUser?.uid
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    func addAnnounce(announce: Announce) {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection("Announces")
        
        do{
            let _ = try collection.addDocument(from: announce)
        } catch {
            print(error)
        }
        
    }
}
