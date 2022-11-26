//
//  UserProfileVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//

import SwiftUI

@MainActor
class UserProfileVM: ObservableObject {
    
    @Inject var getUserProfile: GetUserProfileProtocol
    @Inject var writeUserProfile: WriteUserProfileProtocol
    
    @Published private(set) var userProfile: UserProfile?
    
    var firstName: String {
        get{ userProfile?.firstName ?? "" }
        set { self.userProfile?.firstName = newValue }
    }
    
    var lastName: String {
        get{ userProfile?.lastName ?? "" }
        set { self.userProfile?.lastName = newValue }
    }
    
    var pseudo: String {
        get{ userProfile?.pseudo ?? "" }
        set { self.userProfile?.pseudo = newValue }
    }
    
    var emailAddress: String { userProfile?.emailAddress ?? "" }
    
    var address: String {
        get{ userProfile?.address ?? "" }
        set { self.userProfile?.address = newValue }
    }
    
   var profilePicture = Data()
    
    
    func getUserProfileOrPrepareNewOne() {

        Task{
            let userProfileRes = await getUserProfile.getUserProfileOrPrepareNewOne()
            switch userProfileRes {
            case .success(let userProfile):
                self.userProfile = userProfile
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    
    func saveProfile(img: UIImage?) {
        Task{
            if let img = img {
                await writeUserProfile.SaveProfile(profile: self.userProfile!, dataImg: img.jpegData(compressionQuality: 0.8))
            } else {
                await writeUserProfile.SaveProfile(profile: self.userProfile!, dataImg: nil)
            }
        }
    }
}
