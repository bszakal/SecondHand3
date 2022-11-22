//
//  User.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//

import Foundation

struct UserProfile: Codable, Identifiable, Equatable {
    
    let id: String
    var firstName: String = ""
    var lastName: String = ""
    var pseudo: String = ""
    let emailAddress: String
    var address: String = ""
    var profilePictureUrlStr = ""
    
    var city_PostCode: String {
        let decomposedAddress = address.components(separatedBy: ", ")
        return decomposedAddress.isEmpty ? address : decomposedAddress[1] + " " + decomposedAddress[2]
    }
    
   // static let example = UserProfile(id: "jcmNLTViDBYZSBXKfAKRIISsZLu1", emailAddress: "benjamin.szakal1@gmail.com")
    static let example = UserProfile(id: "test", firstName: "Benjamin", lastName: "Szakal", pseudo: "Zac", emailAddress: "benjamin.szakal1@gmail.com", address: "6 Allee Francois Villon, 38130, Echirolles", profilePictureUrlStr: "")
    
}
