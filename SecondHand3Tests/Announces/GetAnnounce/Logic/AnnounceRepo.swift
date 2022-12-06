//
//  AnnounceRepo.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 30/11/22.
//

@testable import SecondHand3
import XCTest
import Quick
import Nimble
import Swinject
import Combine


class AnnounceRepoSpec: QuickSpec {
    
    override func spec() {
        
        describe("checkForNewAnnouncesFunc") {
            
            it("Announce array publisher publishes when Announce array is updated") {
                let sut = AnnounceRepo()
                
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol {
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        return .success(([Announce.example], nil))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        .success("test")
                    }
                }
                
                
                
                var announceSuscriber = [Announce]()
                var cancellable = Set<AnyCancellable>()
                sut.annoncePublisher
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: {NewValue in
                        announceSuscriber = NewValue})
                    .store(in: &cancellable)
                
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForNewAnnounces()
                

                print(announceSuscriber)
                expect(sut.announces).to(haveCount(1))
                await expect(announceSuscriber).toEventually(haveCount(1))
              
            }
            
            it("Announce array contains 1 item when 1 announce is return from DataSource") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol {
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        return .success(([Announce.example], nil))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        .success("test")
                    }
                }
                
               
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForNewAnnounces()
                expect(sut.announces).to(haveCount(1))
            }
            
            it("Announce array contains same nbre of items returned from DataSource") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol {
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        let arrayOfAnnounce = Array(repeating: Announce.example, count: 6)
                        return .success((arrayOfAnnounce, nil))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        .success("test")
                    }
                }
                
                
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForNewAnnounces()
                expect(sut.announces).to(haveCount(6))
            }
            
            it("Announce array is empty when error is returned from dataSource") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol {
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        
                        let arrayOfAnnounce = Array(repeating: Announce.example, count: 6)
                        
                        enum errorType: Error{
                            case anyError
                        }
                        return .failure(errorType.anyError)
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        .success("test")
                    }
                }
                
               
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForNewAnnounces()
                expect(sut.announces).to(beEmpty())
            }
            
            it("Announce array is replaced by newValue returned by checkForNewAnnounce, not incremented") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol {
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        
                        let arrayOfAnnounce = Array(repeating: Announce.example, count: 6)
                        return .success((arrayOfAnnounce,nil))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        .success("test")
                    }
                }
                
                
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForNewAnnounces()
                await sut.checkForNewAnnounces()
                expect(sut.announces).to(haveCount(6))
            }
        }
        
        describe("checkForMoreAnnounces") {
            it("Announce Array contains same nbre of item as returned by DataSource when announce array is empty before it's called") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol{
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        return .success(([Announce.example], nil))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        return .success("Test")
                    }
                    
                }
                
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForMoreAnnounces()
                expect(sut.announces).to(haveCount(1))
            }
            
            it("Announce Array contains only unique elements if dupes are returned by DataSource") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol{
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        let arrayOfAnnounces = Array(repeating: Announce.example, count: 2)
                        return .success((arrayOfAnnounces, nil))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        return .success("Test")
                    }
                    
                }
                
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForMoreAnnounces()
                expect(sut.announces).to(haveCount(1))
            }
            
            it("Announce array is incremented by nbre of item return by dataSource") {
                let sut = AnnounceRepo()
                
                class firebaseAnnounceMock: FirebaseAnnounceProtocol{
                    func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                        
                        var arrayOfAnnounces = [Announce]()
                        for _ in 1...2 {
                            var announce = Announce.example
                            announce.id = String(Int.random(in: 1...1000000))
                            arrayOfAnnounces.append(announce)
                        }
                        return .success((arrayOfAnnounces, (Date(), "FakeId")))
                    }
                    
                    func getuserUID() async -> Result<String, Error> {
                        return .success("Test")
                    }
                    
                }
                
                sut.firebaseAnnouce = firebaseAnnounceMock()
                await sut.checkForMoreAnnounces()
                await sut.checkForMoreAnnounces()
                expect(sut.announces).to(haveCount(4))
            }
        }
        
        describe("getAnnouncesFilteredFunc") {
            context("When no filter applied") {
                it("returns same nbre of item as DataSource"){
                    let sut = AnnounceRepo()
                    
                    class firebaseAnnounceMock: FirebaseAnnounceProtocol {
                        func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                            
                            return .success(([Announce.example, Announce.example], nil))
                        }
                        
                        func getuserUID() async -> Result<String, Error> {
                            return .success("test")
                        }
                    }
                    
                    
                    sut.firebaseAnnouce = firebaseAnnounceMock()
                    let announcesResult = await sut.getAnnouncesFiltered(text: nil, priceStart: 0, priceEnd: 1000000, category: nil, startDate: nil, myAnnounceOnly: false, announceID: nil)
                    
                    expect(announcesResult).to(beSuccess())
                    switch announcesResult {
                    case .success(let announces):
                        expect(announces).to(haveCount(2))
                    case .failure(_):
                        fail()
                    }
                }
            }
            
            context("When Filters are used") {
                it ("returns the items from DataSource with filtered by the parameters"){
                    let sut = AnnounceRepo()
                    
                    class firebaseAnnounceMock: FirebaseAnnounceProtocol{
                        func getAnnounces(lastDocQuery: (lastUpdateAt: Date, docId: String)?, limit: Int) async -> Result<([SecondHand3.Announce], (lastUpdateAt: Date, docId: String)?), Error> {
                            
                            var arrayOfAnnounces = [Announce]()
                            var announce0 = Announce.example
                            announce0.CreatedAt = Date()
                            announce0.lastUpdatedAt = Date()
                            arrayOfAnnounces.append(announce0)
                            
                            var announce1 = Announce.example
                            announce1.title = "Title"
                            arrayOfAnnounces.append(announce1)
                            
                            var announce3 = Announce.example
                            announce3.price = 21.0
                            arrayOfAnnounces.append(announce3)
                            
                            var announce4 = Announce.example
                            announce4.CreatedAt = Date().addingTimeInterval(-100_000)
                            announce4.lastUpdatedAt = Date().addingTimeInterval(-100_000)
                            arrayOfAnnounces.append(announce4)
                            
                            return .success((arrayOfAnnounces, (Date(), "FakeId")))
                        }
                        
                        func getuserUID() async -> Result<String, Error> {
                            return .success("Test")
                        }
                    }
                    
                    
                    sut.firebaseAnnouce = firebaseAnnounceMock()
                    let announcesResult = await sut.getAnnouncesFiltered(text: "Army", priceStart: 10, priceEnd: 20, category: "Game", startDate: Date().addingTimeInterval(-600), myAnnounceOnly: false, announceID: nil)
                    
                    expect(announcesResult).to(beSuccess())
                    switch announcesResult {
                    case .success(let announces):
                        expect(announces).to(haveCount(1))
                    case .failure(_):
                        fail()
                    }
                }
            }
        }
    }
}
