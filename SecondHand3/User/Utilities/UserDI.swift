//
//  UserDI.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//

import Foundation
import Swinject

class UserAssembler: Assembly {
    
    func assemble(container: Container) {
        container.register(FirebaseUserProfileProtocol.self) { _ in FirebaseUserProfile()}.inObjectScope(.container)
        container.register(GetUserProfileProtocol.self) { _ in GetUserProfile()}.inObjectScope(.container)
        container.register(WriteUserProfileProtocol.self) {_ in WriteUserProfile()}.inObjectScope(.container)
    }
 
}
