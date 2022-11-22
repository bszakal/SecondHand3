//
//  Categories.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 03/11/22.
//
import FirebaseFirestoreSwift
import Foundation

struct Category: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    let Name: String
    let Image: String
    
    static let example = Category(Name: "Books", Image: "https://thumbs.dreamstime.com/z/open-book-19523116.jpg")
    
}
