//
//  MyAnnounceVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//

import SwiftUI

@MainActor
class MyAnnouncesVM: ObservableObject {
    
    @Inject var getAnnounceCase: AnnounceRepoProtocol
    @Published var myAnnounces = [Announce]()
    
    func getMyAnnounce() {
        Task {
            let resultAnnounce = await getAnnounceCase.getAnnouncesFiltered(text: nil, priceStart: 0, priceEnd: 10000, category: nil, startDate: nil, myAnnounceOnly: true, announceID: nil)
            switch resultAnnounce {
            case .success(let success):
                self.myAnnounces = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
