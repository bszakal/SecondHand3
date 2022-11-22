//
//  MessageDI.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 15/11/22.
//

import Foundation
import Swinject

extension ObjectScope {
    static let custom = ObjectScope(storageFactory: PermanentStorage.init)
}

class MessageAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(FirebaseMessageProtocol.self) {_ in FirebaseMessage()}.inObjectScope(.container)
        container.register(MessageGetProtocol.self) {_ in MessageGet()}.inObjectScope(.container)
        //container.register(MessageGetProtocol.self) {_ in MessageGet()}.inObjectScope(.custom)
        container.register(MessageCreateUpdateProtocol.self) {_ in MessageCreateUpdate()}.inObjectScope(.container)
    }
  
}
