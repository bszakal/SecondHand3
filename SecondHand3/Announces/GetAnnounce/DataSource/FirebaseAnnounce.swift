//
//  FirebaseAnnounce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol FirebaseAnnounceProtocol {
    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async ->Result<([Announce], (lastUpdateAt: Date, docId: String)?), Error>
    func getuserUID() async ->Result<String, Error>
}


class FirebaseAnnounce: FirebaseAnnounceProtocol, FirebaseGeneralQuery {
    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = await FirebaseAnnounce.getuserID()
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    
    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async ->Result<([Announce], (lastUpdateAt: Date, docId: String)?), Error> {
        
        let db = Firestore.firestore()
        
        var query: Query
        
        if let lastDocQuery = lastDocQuery{
            query = db.collection("Announces").order(by: "lastUpdatedAt", descending: true).order(by: FirebaseFirestore.FieldPath.documentID(), descending: true).start(after: [lastDocQuery.lastUpdateAt, lastDocQuery.docId]).limit(to: limit)
            
        } else {
            query = db.collection("Announces").order(by: "lastUpdatedAt", descending: true).order(by: FirebaseFirestore.FieldPath.documentID(), descending: true).limit(to: limit)
        }
        
        do{
            
            let querySnapshots = try await query.getDocuments()
            
            if querySnapshots.isEmpty {
                //return empty array and just give back what the lastquerydoc input, no update
                return .success((Array<Announce>(),lastDocQuery))
            } else {
                let announceArray =  try querySnapshots.documents.compactMap { try $0.data(as: Announce.self)}
                if let lastDoc = announceArray.last, let updateTime = lastDoc.lastUpdatedAt, let id = lastDoc.id {
                    return .success((announceArray,(updateTime, id)))
                } else {
                    return .success((announceArray, nil))
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
        
    }
    
}
