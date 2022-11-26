//
//  WriteUserProfile.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//

import Foundation

protocol WriteUserProfileProtocol {
    func SaveProfile(profile: UserProfile, dataImg: Data?) async
}

class WriteUserProfile: WriteUserProfileProtocol {
    
    @Inject var firebaseUserProfile: FirebaseUserProfileProtocol
    
    func SaveProfile(profile: UserProfile, dataImg: Data?) async {
        
        //if user is not logged In then abort
        var profileLocal = profile
        
        let userUIDRes = await firebaseUserProfile.getuserUID()
        switch userUIDRes {
        case .success(_):
            print("")
        case .failure(let failure):
            print(failure.localizedDescription)
            return
        }
    
        // if there is an Image then upload data image to firestorage -> get urls for image
        if let dataImg = dataImg {
            let resultUploadImage = await firebaseUserProfile.uploadImageStorage(photosData: [dataImg])
            switch resultUploadImage {
            case .success(let urls):
                profileLocal.profilePictureUrlStr = urls[0]
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
        
        firebaseUserProfile.addUserProfile(user: profileLocal)
    }
}
