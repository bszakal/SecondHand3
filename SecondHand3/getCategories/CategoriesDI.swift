//
//  CategoriesDI.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 03/11/22.
//

import Foundation
import Swinject

class CategoriesAssembler: Assembly {
    
    func assemble(container: Container) {
        container.register(FirebaseCategoriesProtocol.self) { _  in return FirebaseCategories()}.inObjectScope(.container)
    }
      
}
