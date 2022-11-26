//
//  FirebaseMessage.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum DocChangeType: String {
    case Added, Modified, Removed
}

protocol FirebaseMessageProtocol {
    func getuserUID() async ->Result<String, Error>
    func addNewMessage(message: Message)
    func setMessageToReadStatus(messages: [Message])
    func getMessages2(CompletionHandler: @escaping ([(Message, DocChangeType)], Error?)->Void)
}


class FirebaseMessage: FirebaseMessageProtocol, FirebaseGeneralQuery {
    

    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = await FirebaseMessage.getuserID()
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    func addNewMessage(message: Message) {
        FirebaseMessage.addCodableTypeToCollectionIdFirebaseGenerated(type: message, collection: "Messages")
    }
    
    func setMessageToReadStatus(messages: [Message]) {
        
        for message in messages {
            if let id = message.id {
                FirebaseMessage.addCodableTypeToCollectionSpecificId(type: message, collectionName: "Messages", id: id)
            }
        }
    }
    
    func getMessages2(CompletionHandler: @escaping ([(Message, DocChangeType)], Error?)->Void) {
        
        
        Task{
            let idResult = await getuserUID()
            switch idResult {
            case .success(let success):
            
            let db = Firestore.firestore()
            
            let query = db.collection("Messages").whereField("ids", arrayContains: success)
            
            query.addSnapshotListener { snapshot, err in
                
                guard let documentsChange = snapshot?.documentChanges else {
                    print(err?.localizedDescription as Any)
                    CompletionHandler(Array<(Message, DocChangeType)>(), err)
                    return
                }
                

                let messages: [(Message, DocChangeType)] = documentsChange.compactMap { documentchange -> (Message, DocChangeType)? in
                    do{
                        var changeType: DocChangeType {
                            switch documentchange.type {
                            case .added:
                                return DocChangeType.Added
                            case .modified:
                                return DocChangeType.Modified
                            case .removed:
                                return DocChangeType.Removed
                            }
                        }
                        return (try documentchange.document.data(as: Message.self),changeType)
                        
                    } catch {
                        print(error.localizedDescription)
                        return (nil)
                    }
                }

                CompletionHandler(messages, nil)
                
            }
            case .failure(let failure):
                print(failure.localizedDescription)
                CompletionHandler(Array<(Message, DocChangeType)>(), failure)
            }
        }
    }
    
}
