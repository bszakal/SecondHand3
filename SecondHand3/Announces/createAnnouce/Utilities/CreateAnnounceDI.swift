//
//  CreateAnnounceDI.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 06/11/22.
//

import Foundation
import Swinject

class CreateAnnouncesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(CreateAnnounceFirebaseProtocol.self) { _  in return CreateAnnounceFirebase()}.inObjectScope(.container)
        container.register(CreateAnnounceProtocol.self) { _ in return CreateAnnounce()}.inObjectScope(.container)

         
    }
}
