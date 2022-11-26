//
//  FirebaseStorageGeneralQuery.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 22/11/22.
//
import Firebase
import FirebaseStorage
import Foundation


protocol FirebaseStorageGeneralQuery{
    
}

extension FirebaseStorageGeneralQuery {
    
   static func uploadData(collectionName:String, dataArray: [Data]) async -> Result<[String], Error> {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let collection = storageRef.child(collectionName)
        
        var urls = [String]()
        
        for data in dataArray {
            
            let photoref = collection.child(UUID().uuidString + ".jpeg")
            
            do{
                let _ = try await photoref.putDataAsync(data)
                let url = try await photoref.downloadURL()
                let urlStr = url.absoluteString
                urls.append(urlStr)
                
            } catch{
                print(error.localizedDescription)
                return .failure(error)
            }
        }
        return .success(urls)
        
    }
}
