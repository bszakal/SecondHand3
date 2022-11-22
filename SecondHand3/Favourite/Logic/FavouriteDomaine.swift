//
//  FavouriteDomaine.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 07/11/22.
//
import Combine
import Foundation

protocol FavouriteDomaineProtocol {
    func getFavouriteAnnounce() async -> [Announce]
    func addAnnounceToFavorite(announceID: String) async
    func removeFromFavourite(announce: Announce) async
    func isAnnounceAFavourite(announce: Announce) async -> Bool
    var favourites: Published<[Announce]>.Publisher {get}
}

class FavouriteDomaine: FavouriteDomaineProtocol {
    
    @Inject var firebaseFavourite: FirebaseFavouriteProtocol
    
    @Published private(set) var favouritesPub = [Announce]()
    var favourites: Published<[Announce]>.Publisher{$favouritesPub}
    
    func getFavouriteAnnounce() async -> [Announce]{
        
        let resultId = await firebaseFavourite.getuserUID()
        switch resultId {
            
        case .success(let successId):
            let favourites = await firebaseFavourite.getFavouriteForUser(userId: successId)
            switch favourites {
                
            case .success(let successFav):
                let announcesId = successFav.map{$0.announceID}
                let annouces = await firebaseFavourite.getAnnouncesForIds(announcesId: announcesId)
                switch annouces {
                    
                case .success(let successAnnounces):
                    self.favouritesPub = successAnnounces
                    return successAnnounces
                case .failure(let failure):
                    print(failure.localizedDescription)
                    return Array<Announce>()
                }
      
            case .failure(let failure):
                print(failure.localizedDescription)
                return Array<Announce>()
            }
        case .failure(let failure):
            print(failure.localizedDescription)
            return Array<Announce>()
        }
        
        
    }
    
    func addAnnounceToFavorite(announceID: String) async {
        
        let resultUserID = await firebaseFavourite.getuserUID()
        switch resultUserID {
        case .success(let success):
            
            firebaseFavourite.addAnnounceToFavourite(favourite: Favourite(userID: success, announceID: announceID))
            self.favouritesPub = await self.getFavouriteAnnounce()
            
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    func removeFromFavourite(announce: Announce) async {
        let resultUserID = await firebaseFavourite.getuserUID()
        switch resultUserID {
        case .success(let success):
            
            //get favourites for user
            let favourites = await firebaseFavourite.getFavouriteForUser(userId: success)
            switch favourites {
            case .success(let success):
                
                let favouritesToRemove = success.filter{$0.announceID == announce.id}
                
                for favourite in favouritesToRemove {
                    await firebaseFavourite.removeFromFavorite(favourite: favourite)
                }
                self.favouritesPub = await self.getFavouriteAnnounce()
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    func isAnnounceAFavourite(announce: Announce) async -> Bool {
        
        let favourites = await getFavouriteAnnounce()
        return favourites.contains{$0.id == announce.id}
        
    }
}
