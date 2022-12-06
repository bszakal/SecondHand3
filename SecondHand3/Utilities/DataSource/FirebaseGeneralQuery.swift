//
//  FirebaseGeneralQuery.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 22/11/22.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol FirebaseGeneralQuery {
   
}

extension FirebaseGeneralQuery {
    
    static func getuserID() async -> String? {
        Auth.auth().currentUser?.uid
    }
    
    static func getuserEmailAddress() async ->String? {
        Auth.auth().currentUser?.email
    }
    
    
   static func addCodableTypeToCollectionIdFirebaseGenerated<T:Codable>(type: T, collection: String) -> Result<Bool, Error> {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection(collection)
    
        do{
            let _ = try collection.addDocument(from: type)
            return .success(true)
        } catch {
            print(error)
            return .failure(error)
        }
    }
    
    static func addCodableTypeToCollectionSpecificId<T:Codable>(type: T, collectionName: String, id: String) {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection(collectionName)
        let docRef = collection.document(id)
        
        do{
            try docRef.setData(from: type) {err in
                if let err1 = err {
                    print(err1.localizedDescription)
                }
            }
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
  static  func removeFromCollection(collectionName: String, docId: String) async {
        
        let db = Firestore.firestore()
        do{
            try await db.collection(collectionName).document(docId).delete()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    static func getCodableTypeForStringFilter<T:Codable>(type:T.Type, collectionName: String, filterbyField: (field:String, value: String)?, filterByDocIds: [String]?, orderByField: String? = nil) async ->Result<[T], Error> {
        
        let db = Firestore.firestore()
        var query: Query
        
        if let docIds = filterByDocIds {
            query = db.collection(collectionName).whereField("__name__", in: docIds)
        } else if let fieldFilter = filterbyField {
            query = db.collection(collectionName).whereField(fieldFilter.field, isEqualTo: fieldFilter.value)
        } else {
            query = db.collection(collectionName)
        }
        
        if let orderfield = orderByField {
            query = query.order(by: orderfield, descending: true)
        }
            
        let result = await getDataForQuery(type: type, query: query)
        switch result {
            
        case .success(let success):
            return .success(success)
            
        case .failure(let failure):
            print(failure.localizedDescription)
            return .failure(failure)
        }
    }
    
  static  func getDataForQuery<T: Codable>(type:T.Type, query: Query) async -> Result<[T], Error> {
        
        do{
            let querySnapshots = try await query.getDocuments()
            
            if querySnapshots.isEmpty {
                return .success(Array<T>())
            } else {
                let resultArray =  try querySnapshots.documents.compactMap { try $0.data(as: type)}
                return .success(resultArray)
            }
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
}
