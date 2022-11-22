//
//  FavouriteDI.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 07/11/22.
//

import Foundation
import Swinject

class FavouriteAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(FirebaseFavouriteProtocol.self) { _  in return FirebaseFavourite()}.inObjectScope(.container)
        container.register(FavouriteDomaineProtocol.self) { _  in return FavouriteDomaine()}.inObjectScope(.container)

         
    }
}
