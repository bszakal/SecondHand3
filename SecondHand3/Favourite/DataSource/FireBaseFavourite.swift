//
//  FireBaseAddFavourite.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 07/11/22.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol FirebaseFavouriteProtocol {
    func getuserUID() async ->Result<String, Error>
    func addAnnounceToFavourite(favourite: Favourite)
    func getFavouriteForUser(userId: String) async ->Result<([Favourite]), Error>
    func getAnnouncesForIds(announcesId: [String]) async ->Result<([Announce]), Error>
    func removeFromFavorite(favourite: Favourite) async
}

class FirebaseFavourite: FirebaseFavouriteProtocol, FirebaseGeneralQuery {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func getuserUID() async ->Result<String, Error> {
        let userUID = await FirebaseFavourite.getuserID()
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)
    }
    
  
    func addAnnounceToFavourite(favourite: Favourite) {
         FirebaseFavourite.addCodableTypeToCollectionIdFirebaseGenerated(type: favourite, collection: "Favourites")
    }
    
    
    func getFavouriteForUser(userId: String) async ->Result<([Favourite]), Error> {
        
        return await FirebaseFavourite.getCodableTypeForStringFilter(type: Favourite.self, collectionName: "Favourites", filterbyField: ("userID", userId), filterByDocIds: nil)
    }
    
    func getAnnouncesForIds(announcesId: [String]) async ->Result<([Announce]), Error> {
        
        if announcesId.isEmpty { return .success(Array<Announce>())}
        
        return await FirebaseFavourite.getCodableTypeForStringFilter(type: Announce.self, collectionName: "Announces", filterbyField: nil, filterByDocIds: announcesId)
    }
    
    func removeFromFavorite(favourite: Favourite) async {

        if let id = favourite.id {
            await FirebaseFavourite.removeFromCollection(collectionName: "Favourites", docId: id)
        }
    }
}
