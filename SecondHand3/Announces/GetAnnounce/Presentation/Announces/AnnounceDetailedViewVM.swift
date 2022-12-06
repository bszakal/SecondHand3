//
//  AnnounceDetailedViewVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 11/11/22.
//

import SwiftUI
import Swinject

@MainActor
class AnnounceDetailedVM: ObservableObject {
    
    
    @Inject var favouriteDomaine: FavouriteDomaineProtocol!
    @Inject var getUserDomaine: GetUserProfileProtocol!
    
    @Published private(set) var isAFavourite: Bool = false
    @Published private(set) var userProfileForAnnounce = UserProfile(id: "", emailAddress: "")
    @Published private(set) var currentUserProfile = UserProfile(id: "", emailAddress: "")
    

    func isAFavourite(announce: Announce) {
        Task {
            self.isAFavourite = await favouriteDomaine.isAnnounceAFavourite(announce:announce)
        }
    }
    
    func AddOrRemoveFromFavourite(announce: Announce){
        Task {
            await favouriteDomaine.AddOrRemoveFromFavourite(announce:announce)
            isAFavourite(announce: announce)
        }
    }
    func getUserDetailsForAnnounce(announce: Announce) {
        Task{
            let resultUserProfile = await getUserDomaine.getUserProfileForAnnounce(announce: announce)
            switch resultUserProfile {
            case .success(let success):
                self.userProfileForAnnounce = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getCurrentUserDetails() {
        Task{
            let resultUserProfile = await getUserDomaine.getUserProfile()
            switch resultUserProfile {
            case .success(let success):
                self.currentUserProfile = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}
