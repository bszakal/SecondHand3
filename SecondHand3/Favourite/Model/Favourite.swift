//
//  Favourite.swift
//  SecondHand3
//user id jcmNLTViDBYZSBXKfAKRIISsZLu1
// anouceid: drLmiG3UNEmQhRm1cC76
//  Created by Benjamin Szakal on 07/11/22.
//
import FirebaseFirestoreSwift
import Foundation

struct Favourite: Codable,Identifiable {
    
    @DocumentID var id: String?
    let userID: String
    let announceID: String
    @ServerTimestamp var CreatedAt: Date?
    @ServerTimestamp var lastUpdatedAt: Date?
    
}
