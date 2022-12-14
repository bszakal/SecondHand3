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
    func getUserProfileOrPrepareNewOne() async -> Result<UserProfile, Error>
}


class GetUserProfile: GetUserProfileProtocol {
    
    @Inject var firebaseUserProfile: FirebaseUserProfileProtocol
     
    func getUserProfile() async -> Result<UserProfile, Error> {
        
        let resultUserID = await firebaseUserProfile.getuserUID()
        switch resultUserID {
        case .success(let userId):
            return await firebaseUserProfile.getUserProfile(userUID: userId)
        case .failure(let failure):
            return .failure(failure)
        }
    }

    func getEmailAddress() async ->Result<String, Error> {
         await firebaseUserProfile.getuserEmailAddress()
    }
    
    func getUserID() async -> Result<String, Error> {
         await firebaseUserProfile.getuserUID()
    }
    
    func getUserProfileForAnnounce(announce: Announce) async -> Result<UserProfile, Error> {
         await firebaseUserProfile.getUserProfile(userUID: announce.userUID)
    }
    
    func getUserProfileForUserId(userID: String) async -> Result<UserProfile, Error> {        
         await firebaseUserProfile.getUserProfile(userUID: userID)
    }
    
    func getUserProfileOrPrepareNewOne() async -> Result<UserProfile, Error> {

            let resultUserProfile = await getUserProfile()
            switch resultUserProfile {
            case .success(let userProfile):
                return .success(userProfile)
            case .failure(_):
                // if not user profile exists in database then get userID and email (automatically generated by Firebase when user registered) to start new profile
                let resultEmailAddress = await getEmailAddress()
                switch resultEmailAddress {
                case .success(let emailAddress):
                    let resultUserID = await getUserID()
                    switch resultUserID {
                    case .success(let userID):
                        return .success(UserProfile(id: userID, emailAddress: emailAddress))
                        
                    case .failure(let err):
                        return .failure(err)
                    }
                    
                case .failure(let err):
                    return .failure(err)
                }
     
            }
        
    }
    
}
