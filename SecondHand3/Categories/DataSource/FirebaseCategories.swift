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


class FirebaseCategories: FirebaseCategoriesProtocol, FirebaseGeneralQuery {
    
    
    func getCategories() async ->Result<[Category], Error> {
        
      return await FirebaseCategories.getCodableTypeForStringFilter(type: Category.self, collectionName: "Categories", filterbyField: nil, filterByDocIds: nil)
        
    }
    
}
