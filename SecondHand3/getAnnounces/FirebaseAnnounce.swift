//
//  FirebaseAnnounce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//
import FirebaseFirestore
import Foundation

protocol FirebaseAnnounceProtocol {
    func getAnnounces2(lastDocQuery: QueryDocumentSnapshot?, limit: Int) async ->Result<([Announce], QueryDocumentSnapshot?), Error>
}


class FirebaseAnnounce: FirebaseAnnounceProtocol {
    
    
    func getAnnounces2(lastDocQuery: QueryDocumentSnapshot?, limit: Int) async ->Result<([Announce], QueryDocumentSnapshot?), Error> {
        
        let db = Firestore.firestore()
        
        var query: Query
        
        
        if let lastDocQuery = lastDocQuery{
             query = db.collection("Announces").order(by: "lastUpdatedAt", descending: true).start(afterDocument: lastDocQuery).limit(to: limit)
            
        } else {
            query = db.collection("Announces").order(by: "lastUpdatedAt", descending: true).limit(to: limit)
            
        }
        
        do{
            
            let querySnapshots = try await query.getDocuments()
            
            if querySnapshots.isEmpty {
                //return empty array and just give back what the lastquerydoc input, no update
                return .success((Array<Announce>(),lastDocQuery))
            } else {
                let announceArray =  try querySnapshots.documents.compactMap { try $0.data(as: Announce.self)}
                return .success((announceArray,querySnapshots.documents.last))
            }   
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
        
    }
    
}
