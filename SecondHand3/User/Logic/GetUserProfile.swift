//
//  UserProfileDomaine.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//

import Foundation

protocol GetUserProfileProtocol {
    func getUserProfile() async -> Result<UserProfile, Error>
    func getEmailAddress() async ->Result<String, Error>
    func getUserID() async -> Result<String, Error>
    func getUserProfileForAnnounce(announce: Announce) async -> Result<UserProfile, Error>
    func getUserProfileForUserId(userID: String) async -> Result<UserProfile, Error> 
}


class GetUserProfile: GetUserProfileProtocol {
    
    @Inject var firebaseUserProfile: FirebaseUserProfileProtocol
     
    func getUserProfile() async -> Result<UserProfile, Error> {
        
        let resultUserID = await firebaseUserProfile.getuserUID()
        switch resultUserID {
        case .success(let userId):
            
            let resultUserProfile = await firebaseUserProfile.getUserProfile(userUID: userId)
            switch resultUserProfile {
            case .success(let userProfile):
                
                return .success(userProfile)
            
            case .failure(let failure):
                return .failure(failure)
            }
    
        case .failure(let failure):
            return .failure(failure)
        }
   
    }

    func getEmailAddress() async ->Result<String, Error> {
        
        let resultUserEmail = await firebaseUserProfile.getuserEmailAddress()
        switch resultUserEmail {
        case .success(let email):
            return .success(email)
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
    func getUserID() async -> Result<String, Error> {
        
        let resultUserID = await firebaseUserProfile.getuserUID()
        switch resultUserID {
        case .success(let userId):
            return .success(userId)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    func getUserProfileForAnnounce(announce: Announce) async -> Result<UserProfile, Error> {
        
        let resultUserProfile = await firebaseUserProfile.getUserProfile(userUID: announce.userUID)
        switch resultUserProfile {
        case .success(let userProfile):
            
            return .success(userProfile)
        
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    func getUserProfileForUserId(userID: String) async -> Result<UserProfile, Error> {
        
        let resultUserProfile = await firebaseUserProfile.getUserProfile(userUID: userID)
        switch resultUserProfile {
        case .success(let userProfile):
            
            return .success(userProfile)
        
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
}
