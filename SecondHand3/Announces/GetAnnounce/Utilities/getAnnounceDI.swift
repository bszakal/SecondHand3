//
//  getAnnounceDI.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//

import Foundation
import Swinject

class getAnnouncesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(FirebaseAnnounceProtocol.self) { _  in return FirebaseAnnounce()}.inObjectScope(.container)
        container.register(AnnounceRepoProtocol.self) { _  in return AnnounceRepo()}.inObjectScope(.container)

         
    }
}


