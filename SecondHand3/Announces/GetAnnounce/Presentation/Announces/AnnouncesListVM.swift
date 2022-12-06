//
//  AnnouncesListVM.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//
import Combine
import SwiftUI

@MainActor
class AnnouncesListVM: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()

    
    @Published private(set) var announces = [Announce]()
    @Published private(set) var favourites = [Announce]()
    
    @Published private(set) var useTempData = false
    @Published private(set) var tempData = [Announce]()
    
    @Inject var announceRepo: AnnounceRepoProtocol!
    @Inject var favouriteDomaine: FavouriteDomaineProtocol!

    
    init() {
        useTempData = true
        self.tempData = loadTempData()
    }
    
    func suscribeToAnnounceRepoArray() {
        self.announceRepo.annoncePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] NewValue in
                self?.announces = NewValue
            }
            .store(in: &cancellables)
    }
    
    func CheckNewAnnounces() {
        Task{
           await announceRepo.checkForNewAnnounces()
            useTempData = false
        }
    }
    
    func checkForMoreAnnouces() {
        Task{
            await announceRepo.checkForMoreAnnounces()
        }
    }
    
    func isLastAnnounce(announce: Announce) ->Bool {
        if let lastElement = self.announces.last {
            return announce.id == lastElement.id
        }
        return false
    }
    
    func getAnnouncesFiltered(searchText: String, priceStart: Double, priceEnd: Double, category: String, startDate: Date) {
        
        var formattedSearchText: String?
        if searchText != "" {
            formattedSearchText = searchText
        }
        var formattedCategory: String?
        if category != "Any" {
            formattedCategory = category
        }

        Task{
            let result = await announceRepo.getAnnouncesFiltered(text: formattedSearchText, priceStart:priceStart, priceEnd: priceEnd, category: formattedCategory, startDate: startDate, myAnnounceOnly: false, announceID: nil)
            switch result {
            case .success(let success):
                self.announces = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.useTempData = false
        }
    }
    
    func getFavourite() {
        Task {
            self.favourites = await favouriteDomaine.getFavouriteAnnounce()
        }
    }
    
    func isAFavouriteAnnounce(announceId: String) -> Bool {
         favourites.contains (where: {$0.id == announceId})
    }
    
    func AddOrRemoveFromFavourite(announce: Announce){
        Task {
            await favouriteDomaine.AddOrRemoveFromFavourite(announce:announce)
            getFavourite()
        }
    }
    
    func loadTempData() -> [Announce] {
        var tempData = Array(repeating: Announce.example, count: 10)
        for index in tempData.indices {
            tempData[index].id = UUID().uuidString
        }
        return tempData
    }
}
