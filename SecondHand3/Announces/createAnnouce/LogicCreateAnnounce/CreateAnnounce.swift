//
//  CreateAnnounce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 06/11/22.
//

import Foundation



protocol CreateAnnounceProtocol {
    
    func createAnnounce(title: String, description: String, price: Double, category: String, size: String, condition: String, deliveryType: String, address: String, images: [Data]) async
}

class CreateAnnounce: CreateAnnounceProtocol {
    
    
    @Inject var createAnnounceFirebase: CreateAnnounceFirebaseProtocol
    
    
    func createAnnounce(title: String, description: String, price: Double, category: String, size: String, condition: String, deliveryType: String, address: String, images: [Data]) async {
        
        //if user is not logged In then abort
        var userID = ""
        
        let userUIDRes = await createAnnounceFirebase.getuserUID()
        switch userUIDRes {
        case .success(let success):
            userID = success
        case .failure(let failure):
            print(failure.localizedDescription)
            return
        }
    
        // upload data image to firestorage -> get urls for image -> Upload complete announce
        let resultUploadImage = await createAnnounceFirebase.uploadImageStorage(photosData: images)
        
            
            
            switch resultUploadImage {
            case .success(let success):
                
                let announce = Announce(title: title, description: description, price: price, category: category, size: size, condition: condition, deliveryType: deliveryType, address: address, userUID: userID, imageRefs: success)
                
                self.createAnnounceFirebase.addAnnounce(announce: announce)
                
            case .failure(let failure):
                print(failure.localizedDescription)
                return
            }
            
        
    }
    
}
