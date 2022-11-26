//
//  LoggingState.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 30/10/22.
//
import Combine
import SwiftUI

class LoginState: ObservableObject {
    
    @Published var isLoggedIn = false
    
    private var cancellable = Set<AnyCancellable>()
    
    @Inject
    var logger: loggerProtocol
    
    init() {
        
        self.isLoggedIn = logger.getLoginState()
        
        logger.IsSignedInPublished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.isLoggedIn = newValue
            }
            .store(in: &cancellable)
    }
    
}
