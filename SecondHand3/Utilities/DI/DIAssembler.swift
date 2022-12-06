//
//  DIAssembler.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 30/10/22.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<Component> {
    var wrappedValue: Component
    init() {
       self.wrappedValue = Resolver.shared.resolve(Component.self)
    }
}


class Resolver {
    static let shared = Resolver()
    //static let container = Container()
    var assembler = Assembler([LoggerAssembly(), getAnnouncesAssembly(), CategoriesAssembler(), CreateAnnouncesAssembly(), FavouriteAssembly(), UserAssembler(), MessageAssembly()])
        //, container: container

    func resolve<T>(_ type: T.Type) -> T {
        assembler.resolver.resolve(T.self)!
    }

}


