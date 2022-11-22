//
//  CategoriesViewVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 03/11/22.
//

import SwiftUI

@MainActor
class CategoriesVM: ObservableObject {
    
    
    @Inject var fetcher: FirebaseCategoriesProtocol
    
    @Published private(set) var categories = [Category]()
    
    func getCategories(){
        
        Task{
            let resut = await fetcher.getCategories()
            switch resut {
            case .success(let success):
                self.categories = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        }
    }
    
}
