//
//  Announce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//
import FirebaseFirestoreSwift
import Foundation

struct Announce: Identifiable, Codable {
    
    @DocumentID var id: String?
    var title: String
    var description: String
    var price: Double
    let category: String
    var size: String
    var condition: String
    var deliveryType: String
    var address: String
    let userUID: String?
    var imageRefs:[String]
    @ServerTimestamp var CreatedAt: Date?
    @ServerTimestamp var lastUpdatedAt: Date?
    
    var city_PostCode: String {
        let decomposedAddress = address.components(separatedBy: ", ")
        return decomposedAddress.isEmpty ? address : decomposedAddress[1] + " " + decomposedAddress[2]
    }

}
