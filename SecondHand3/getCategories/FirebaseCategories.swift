//
//  FirebaseCategories.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 03/11/22.
//

import FirebaseFirestore
import Foundation

protocol FirebaseCategoriesProtocol {
    func getCategories() async ->Result<[Category], Error>
}


class FirebaseCategories: FirebaseCategoriesProtocol {
    
    
    func getCategories() async ->Result<[Category], Error> {
        
        let db = Firestore.firestore()
        
        let query = db.collection("Categories")
        
        do{
            let querySnapshots = try await query.getDocuments()
            
            if querySnapshots.isEmpty {
                //return empty array and just give back what the lastquerydoc input, no update
                return .success(Array<Category>())
            } else {
                let categoriesArray =  try querySnapshots.documents.compactMap { try $0.data(as: Category.self)}
                return .success(categoriesArray)
            }
            
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
        
    }
    
}
