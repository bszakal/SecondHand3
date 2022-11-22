//
//  DI_Logger.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 30/10/22.
//

import Foundation
import Swinject

class LoggerAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(GoogleSignInProtocol.self) { _  in return GoogleSignIn()}.inObjectScope(.container)
        container.register(FacebookSignInProtocol.self) {_ in return FacebookSign()}.inObjectScope(.container)
        container.register(FireBaseSignInProtocol.self) {_ in return FireBaseSignIn()}.inObjectScope(.container)
        container.register(loggerProtocol.self) { _ in return Logger()}.inObjectScope(.container)
         
    }
}
