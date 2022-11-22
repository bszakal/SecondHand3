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
    func getMessages(CompletionHandler: @escaping ([Message], Error?)->Void)
    func addNewMessage(message: Message)
    func setMessageToReadStatus(messages: [Message])
    func getMessages2(CompletionHandler: @escaping ([(Message, DocChangeType)], Error?)->Void)
    
}


class FirebaseMessage: FirebaseMessageProtocol {
    

    
    enum loginError: Error {
        case userNotLoggedIn
    }
    
    func getuserUID() async ->Result<String, Error> {
        
        let userUID = Auth.auth().currentUser?.uid
        return userUID != nil ? .success(userUID!) : .failure(loginError.userNotLoggedIn)

    }
    
    func getMessages(CompletionHandler: @escaping ([Message], Error?)->Void) {
        
        
        Task{
            let idResult = await getuserUID()
            switch idResult {
            case .success(let success):
            
            let db = Firestore.firestore()
            
            let query = db.collection("Messages").whereField("ids", arrayContains: success)
            
            query.addSnapshotListener { snapshot, err in
                guard let documents = snapshot?.documents else {
                    print(err?.localizedDescription as Any)
                    CompletionHandler(Array<Message>(), err)
                    return
                }
        
                let messages = documents.compactMap { document -> Message? in
                    do{
                        return try document.data(as: Message.self)
                    } catch {
                        print(error.localizedDescription)
                        return nil
                    }
                }
                
                CompletionHandler(messages, nil)
                
            }
            case .failure(let failure):
                print(failure.localizedDescription)
                CompletionHandler(Array<Message>(), failure)
            }
        }
    }
    
    func addNewMessage(message: Message) {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection("Messages")
        
        
        do{
            let _ = try collection.addDocument(from: message)
            //let _ = try await collection.addDocument(
        } catch {
            print(error)
        }
        
    }
    
    func setMessageToReadStatus(messages: [Message]) {
        
        let firestore = Firestore.firestore()
        let collection = firestore.collection("Messages")
        for message in messages {
            let docRef = collection.document(message.id ?? "")
            
            do{
                try docRef.setData(from: message) {err in
                    if let err1 = err {
                        print(err1.localizedDescription)
                    }
                }
            } catch{
                print(error.localizedDescription)
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
                        print(changeType)
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
