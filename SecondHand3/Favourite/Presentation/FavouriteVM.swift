//
//  FavouriteVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 07/11/22.
//
import Combine
import SwiftUI

@MainActor
class FavouriteVM: ObservableObject {
    
    @Inject var favouriteDomain: FavouriteDomaineProtocol
    
    @Published private(set) var favouriteAnnounces = [Announce]()
    @Published private(set) var finishedLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        favouriteDomain.favourites
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] newValue in
                self?.favouriteAnnounces = newValue
            })
            .store(in: &cancellables)
 
    }
    
    func getFavourites() {
        Task{
            let _ = await favouriteDomain.getFavouriteAnnounce()
            finishedLoading = true
        }
    }
    
    func AddOrRemoveFromFavourite(announce: Announce){
        Task {
            await favouriteDomain.AddOrRemoveFromFavourite(announce:announce)
        }
    }
    
}
