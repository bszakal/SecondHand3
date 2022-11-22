//
//  MyAccountVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 21/11/22.
//

import SwiftUI

class MyAccountVM: ObservableObject {
    
    @Inject var logger: loggerProtocol
   
    func logOut() {
        logger.logOut()
    }
    
}
