//
//  AnnounceRepo.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//
import Combine
import Foundation

protocol AnnounceRepoProtocol{
    var annoncePublisher: Published<[Announce]>.Publisher{get}
    func checkForNewAnnounces() async
    func checkForMoreAnnounces() async
    func getAnnouncesFiltered(text: String?, priceStart: Double, priceEnd: Double, category: String?, startDate: Date?, myAnnounceOnly: Bool, announceID: String?) async ->Result<[Announce], Error>
}

class AnnounceRepo: AnnounceRepoProtocol {
    
    @Inject var firebaseAnnouce: FirebaseAnnounceProtocol!
    
    @Published private(set) var announces = [Announce]()
    var annoncePublisher: Published<[Announce]>.Publisher{$announces}
    
    private var lastDocLastUpdateTime: (Date, String)?
    
    func checkForNewAnnounces() async {
        
        let resuls = await firebaseAnnouce.getAnnounces(lastDocQuery: nil, limit: 6)
        
        switch resuls {
        case .success(let success):
            if isThereNewAnnounces(announces: success.0) {
                self.lastDocLastUpdateTime = success.1
                self.announces = success.0
            }
        case .failure(let failure):
            print(failure.localizedDescription)
           return
        }
        
    }
    
    func checkForMoreAnnounces() async {
        
        let resuls = await firebaseAnnouce.getAnnounces(lastDocQuery: lastDocLastUpdateTime, limit: 6)
        
        switch resuls {
        case .success(let success):

            self.lastDocLastUpdateTime = success.1
            for succes in success.0 {
                //somtimes Firebase include last doc from previous query instead of starting after so adding extra check to make sure no dupe added
                if self.announces.contains(where: {$0.id == succes.id}) {
                } else {
                    self.announces.append(succes)
                }
            }
        case .failure(let failure):
            print(failure.localizedDescription)
           return
        }
        
    }
    
    private func isThereNewAnnounces(announces: [Announce]) -> Bool {
        self.announces.contains { $0.id == announces.first?.id} ? false : true
    }
    
    func getAnnouncesFiltered(text: String?, priceStart: Double, priceEnd: Double, category: String?, startDate: Date?, myAnnounceOnly: Bool, announceID: String?) async ->Result<[Announce], Error>{
      
        let result = await firebaseAnnouce.getAnnounces(lastDocQuery: nil, limit: 1000)
        
        var tempResult = [Announce]()
        switch result {
        case .success(let success):
            tempResult = success.0
        case .failure(let failure):
            return .failure(failure)
        }
        
        if let text = text {
            tempResult = tempResult.filter{$0.title.contains(text)}
        }
        
        tempResult = tempResult.filter{$0.price >= priceStart && $0.price <= priceEnd}
        
        if let category = category {
            tempResult = tempResult.filter{$0.category == category}
        }
        
        if let startDate = startDate {
            tempResult = tempResult.filter{ $0.lastUpdatedAt ?? Date() > startDate}
        }
        
        if myAnnounceOnly{
            let resultId = await firebaseAnnouce.getuserUID()
            switch resultId {
            case .success(let successId):
                tempResult = tempResult.filter{$0.userUID == successId}
                
            case .failure(let failureId):
                return .failure(failureId)
            }
        }
        
        if let id = announceID {
            tempResult = tempResult.filter{$0.id == id}
        }
        
        return .success(tempResult)
    }
    
}
