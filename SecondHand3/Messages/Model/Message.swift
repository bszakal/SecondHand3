//
//  Message.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//
import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Message: Identifiable, Codable, Hashable, Comparable {

    
    @DocumentID var id: String?
    let announceID: String
    let ids: [String]
    let senderID: String
    let receiverID: String
    var messageContent: String
    var hasBeenRead: Bool
    @ServerTimestamp var createdAt: Date?
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        lhs.createdAt ?? Date() < rhs.createdAt ?? Date()
    }
    
    static let exampleReceived1 = Message(id: "example1", announceID: "aiddaeYQW9i47yOZNHu8", ids: ["jcmNLTViDBYZSBXKfAKRIISsZLu1","E5WSt2dNXsWRaZGHUp9EBhESSPK2"], senderID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", receiverID: "E5WSt2dNXsWRaZGHUp9EBhESSPK2", messageContent: "is still available?", hasBeenRead: false, createdAt: Date().addingTimeInterval(-1000))
    static let exampleReceived2 = Message(id: "example2", announceID: "aiddaeYQW9i47yOZNHu8", ids: ["jcmNLTViDBYZSBXKfAKRIISsZLu1","E5WSt2dNXsWRaZGHUp9EBhESSPK2"], senderID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", receiverID: "E5WSt2dNXsWRaZGHUp9EBhESSPK2", messageContent: "I would be interested if still available, and you can do something on the price?", hasBeenRead: false, createdAt: Date().addingTimeInterval(-500))
    static let exampleReceived3 = Message(id: "example3", announceID: "aiddaeYQW9i47yOZNHu8", ids: ["jcmNLTViDBYZSBXKfAKRIISsZLu1","E5WSt2dNXsWRaZGHUp9EBhESSPK2"], senderID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", receiverID: "E5WSt2dNXsWRaZGHUp9EBhESSPK2", messageContent: "Hi There", hasBeenRead: false, createdAt: Date().addingTimeInterval(-100000))
    static let exampleReceived4 = Message(id: "example4", announceID: "aiddaeYQW9i47yOZNHu8", ids: ["E5WSt2dNXsWRaZGHUp9EBhESSPK2","jcmNLTViDBYZSBXKfAKRIISsZLu1"], senderID: "E5WSt2dNXsWRaZGHUp9EBhESSPK2", receiverID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", messageContent: "Hello", hasBeenRead: false, createdAt: Date().addingTimeInterval(-99000))
}

// AnnounceID aiddaeYQW9i47yOZNHu8
// senderID jcmNLTViDBYZSBXKfAKRIISsZLu1   New Sender ExJ622NUGwc9QiSfdLeNIk0nl973
// receiverID E5WSt2dNXsWRaZGHUp9EBhESSPK2

struct Chat: Identifiable, Codable, Hashable {
    let id: String  // id must always been announceID + idOtherUser
    let announceID: String
    let idOtherUser: String
    var messages: [Message]
    
    static let example = Chat(id: "test", announceID: "aiddaeYQW9i47yOZNHu8", idOtherUser: "jcmNLTViDBYZSBXKfAKRIISsZLu1", messages: [Message.exampleReceived1, Message.exampleReceived2, Message.exampleReceived3, Message.exampleReceived4])
}
