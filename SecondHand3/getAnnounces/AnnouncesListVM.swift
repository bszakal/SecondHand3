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
    @Published var announces = [Announce]()
    
    @Inject var firebase: FirebaseAnnounceProtocol
    @Inject var announceRepo: AnnounceRepoProtocol
    
    init() {
        announceRepo.annoncePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] NewValue in
                self?.announces = NewValue
            }
            .store(in: &cancellables)
    }
    
    func CheckNewAnnounces() {
        Task{
           await announceRepo.checkForNewAnnounces()
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
            let result = await announceRepo.getAnnouncesFiltered(text: formattedSearchText, priceStart:priceStart, priceEnd: priceEnd, category: formattedCategory, startDate: startDate)
            switch result {
            case .success(let success):
                self.announces = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        
    }
    
}
