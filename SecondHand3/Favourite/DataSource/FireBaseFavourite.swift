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

class FirebaseFavourite: FirebaseFavouriteProtocol {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = Auth.auth().currentUser?.uid
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    
    
    func addAnnounceToFavourite(favourite: Favourite) {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection("Favourites")
        
        
        do{
            let _ = try collection.addDocument(from: favourite)
            //let _ = try await collection.addDocument(
        } catch {
            print(error)
        }
        
    }
    
    func getFavouriteForUser(userId: String) async ->Result<([Favourite]), Error> {
        
        let db = Firestore.firestore()
        let query = db.collection("Favourites").whereField("userID", isEqualTo: userId)
            
        do{
            
            let querySnapshots = try await query.getDocuments()
            
            if querySnapshots.isEmpty {
                //return empty array and just give back what the lastquerydoc input, no update
                return .success(Array<Favourite>())
            } else {
                let favouriteArray =  try querySnapshots.documents.compactMap { try $0.data(as: Favourite.self)}
                return .success(favouriteArray)
            }
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
        
    }
    
    func getAnnouncesForIds(announcesId: [String]) async ->Result<([Announce]), Error> {
        
        let db = Firestore.firestore()
        //let  query = db.collection("Favourites").whereField("id", in: announcesId).order(by: "lastUpdatedAt", descending: true)
        if announcesId.isEmpty { return .success(Array<Announce>())}
        let  query = db.collection("Announces").whereField("__name__", in: announcesId)
                
        do{
            
            let querySnapshots = try await query.getDocuments()
            
            if querySnapshots.isEmpty {
                //return empty array and just give back what the lastquerydoc input, no update
                return .success(Array<Announce>())
            } else {
                let announceArray =  try querySnapshots.documents.compactMap { try $0.data(as: Announce.self)}
                return .success(announceArray)
            }
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
        
    }
    
    func removeFromFavorite(favourite: Favourite) async {

        let db = Firestore.firestore()
        do{
            if let id = favourite.id {
               try await db.collection("Favourites").document(id).delete()
            }
        }catch {
            print(error.localizedDescription)
        }
    }
}
