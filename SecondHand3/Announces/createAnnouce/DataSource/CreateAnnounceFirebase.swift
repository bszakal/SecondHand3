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
    func addAnnounce(announce: Announce) -> Result<Bool, Error>
}


class CreateAnnounceFirebase: CreateAnnounceFirebaseProtocol, FirebaseGeneralQuery, FirebaseStorageGeneralQuery {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error> {
        await CreateAnnounceFirebase.uploadData(collectionName: "imagesAnnounces", dataArray: photosData)
    }
  
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = await CreateAnnounceFirebase.getuserID()
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    func addAnnounce(announce: Announce) -> Result<Bool, Error> {
        return CreateAnnounceFirebase.addCodableTypeToCollectionIdFirebaseGenerated(type: announce, collection: "Announces")
    }
}
