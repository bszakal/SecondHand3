//
//  CreateAnnounceVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 05/11/22.
//

import SwiftUI

@MainActor
class CreateAnnounceVM: ObservableObject {
    
    
    @Inject var fetcher: FirebaseCategoriesProtocol!
    @Inject var createAnnounce: CreateAnnounceProtocol!
    
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
    
    func uploadAnnounce(title: String, description: String, price: Double, category: String, condition: String, deliveryType: String, address: String, images: [UIImage]) async -> Result<Bool, Error> {
        
        let size = "XS"
        
        let ImgsAsData = images.compactMap{$0.jpegData(compressionQuality: 0.8)}
        
        //Task {
            return await createAnnounce.createAnnounce(title:title,
                                          description:description,
                                          price:price,
                                          category:category,
                                          size:size,
                                          condition:condition,
                                          deliveryType:deliveryType,
                                          address:address,
                                          images:ImgsAsData)
        //}
        
    }
    
}
