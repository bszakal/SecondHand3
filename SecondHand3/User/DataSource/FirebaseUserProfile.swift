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

class FirebaseUserProfile: FirebaseUserProfileProtocol, FirebaseGeneralQuery, FirebaseStorageGeneralQuery {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    enum ErrorType: Error {
        case isEmpty
    }
    
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = await FirebaseUserProfile.getuserID()
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    func getuserEmailAddress() async ->Result<String, Error> {
        
        let userUID = await FirebaseUserProfile.getuserEmailAddress()
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    
    func getUserProfile(userUID: String) async -> Result<UserProfile, Error> {
        
        let result = await FirebaseUserProfile.getCodableTypeForStringFilter(type: UserProfile.self, collectionName: "UserProfiles", filterbyField: nil, filterByDocIds: [userUID])
        switch result {
        case .success(let success):
            if success.isEmpty{
                // modify behavior of general query to return error if empty
                return .failure(ErrorType.isEmpty)
            } else {
                return .success(success[0])
            }
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
        
    }
    
    func DeleteUserProfile(user: UserProfile) async -> Error?{
        await FirebaseUserProfile.removeFromCollection(collectionName: "UserProfiles", docId: user.id)
        return nil
    }
    
    func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error> {
         await FirebaseUserProfile.uploadData(collectionName: "imagesProfiles", dataArray: photosData)
    }
    
    func addUserProfile(user: UserProfile) {
        FirebaseUserProfile.addCodableTypeToCollectionSpecificId(type: user, collectionName: "UserProfiles", id: user.id)
    }
    
    
}
