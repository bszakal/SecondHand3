//
//  Announce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//
import FirebaseFirestoreSwift
import Foundation

struct Announce: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var title: String
    var description: String
    var price: Double
    let category: String
    var size: String
    var condition: String
    var deliveryType: String
    var address: String
    let userUID: String
    var imageRefs:[String]
    @ServerTimestamp var CreatedAt: Date?
    @ServerTimestamp var lastUpdatedAt: Date?
    
    var city_PostCode: String {
        let decomposedAddress = address.components(separatedBy: ", ")
        return decomposedAddress.isEmpty ? address : decomposedAddress[1] + " " + decomposedAddress[2]
    }
    
    static let imageExample = ["https://firebasestorage.googleapis.com/v0/b/testlogin-zac.appspot.com/o/imagesAnnounces%2F148C53C3-556B-4684-A50A-24405BD7587B.jpeg?alt=media&token=b2a7f2d3-b626-4f0f-9452-4d97899f86aa", "https://firebasestorage.googleapis.com:443/v0/b/testlogin-zac.appspot.com/o/imagesAnnounces%2F7CA6876A-B126-47FD-9BBE-9937D6399BC9.jpeg?alt=media&token=46bf5261-db6f-43d7-8cc1-7c22f51379b9"]
    static let example = Announce(id: "example", title: "Army of Two", description: "Best Coop game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: imageExample)
    static let exampleBadImageUrl = Announce(id: UUID().uuidString, title: "Army of Two", description: "Best Coop game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: ["badUrl, BadUrl"])

}
