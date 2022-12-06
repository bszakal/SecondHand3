//
//  AnnouncesListVM.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 03/12/22.
//
@testable import SecondHand3
import Nimble
import Quick
import XCTest
import Swinject



@MainActor



class AnnouncesListVMSpec: QuickSpec {
    
    override func spec() {
      
        describe("CheckNewAnnouncesFunc") {
          
                it("Announce array is updated with Announces published from AnnonceRepo"){
                    let sut = AnnouncesListVM()
                    
                    class AnnounceRepoMock: AnnounceRepoProtocol {
                        var test = "TestMock"
                        @Published private(set) var announces = [Announce]()
                        var annoncePublisher: Published<[SecondHand3.Announce]>.Publisher{$announces}
                        
                        func checkForNewAnnounces() async {
                            self.announces = [Announce.example, Announce.example]
                        }
                        
                        func checkForMoreAnnounces() async {
                            
                        }
                        
                        func getAnnouncesFiltered(text: String?, priceStart: Double, priceEnd: Double, category: String?, startDate: Date?, myAnnounceOnly: Bool, announceID: String?) async -> Result<[SecondHand3.Announce], Error> {
                            return .failure("Unused" as! any Error)
                        }
                    }

                    
                    sut.announceRepo = AnnounceRepoMock()
                    sut.suscribeToAnnounceRepoArray()
                    
                    sut.CheckNewAnnounces()
                    await expect(sut.announces).toEventually(haveCount(2))
                    expect(sut.useTempData) == false
                }
            
            }
        
        describe("checkForMoreAnnouces") {
           
                it("updates announce Array when values are published from Announce repo"){
                    let sut = AnnouncesListVM()
                    
                    class AnnounceRepoMock: AnnounceRepoProtocol {
                        @Published private(set) var announces = [Announce]()
                        var annoncePublisher: Published<[SecondHand3.Announce]>.Publisher{$announces}
                        
                        func checkForNewAnnounces() async {
                        }
                        
                        func checkForMoreAnnounces() async {
                            self.announces = [Announce.example, Announce.example]

                        }
                        
                        func getAnnouncesFiltered(text: String?, priceStart: Double, priceEnd: Double, category: String?, startDate: Date?, myAnnounceOnly: Bool, announceID: String?) async -> Result<[SecondHand3.Announce], Error> {
                            return .failure("Unused" as! any Error)
                        }
                    }
                    
                    
                    sut.announceRepo = AnnounceRepoMock()
                    sut.suscribeToAnnounceRepoArray()
                    
                    sut.checkForMoreAnnouces()
                    await expect(sut.announces).toEventually(haveCount(2))
                }
            
        }
            
        describe("checkForMoreAnnouces") {
            it("sends back true result if announce tested is last one of the array") {
                let sut = AnnouncesListVM()
                
                class AnnounceRepoMock: AnnounceRepoProtocol {
                    @Published var announces = [Announce]()
                    var annoncePublisher: Published<[SecondHand3.Announce]>.Publisher{$announces}
                    
                    func checkForNewAnnounces() async {
                        var announce1 = Announce.example
                        announce1.id = "ID1"
                        var announce2 = Announce.example
                        announce2.id = "ID2"
                        
                        self.announces = [announce1, announce2]
                    }
                    
                    func checkForMoreAnnounces() async {
                        
                    }
                    
                    func getAnnouncesFiltered(text: String?, priceStart: Double, priceEnd: Double, category: String?, startDate: Date?, myAnnounceOnly: Bool, announceID: String?) async -> Result<[SecondHand3.Announce], Error> {
                        return .failure("error" as! any Error)
                    }
                }
                
                sut.announceRepo = AnnounceRepoMock()
                sut.suscribeToAnnounceRepoArray()
                sut.CheckNewAnnounces()
                
                await expect(sut.announces).toEventually(haveCount(2))
                
                var announceToTest = Announce.example
                announceToTest.id = "ID2"
                
                expect(sut.isLastAnnounce(announce: announceToTest)).to(beTrue())
                
            }
        }
        
        describe("getAnnouncesFiltered") {
            it("update announce array if result are returned from Announce Repo") {
                let sut = AnnouncesListVM()
                
                class AnnounceRepoMock: AnnounceRepoProtocol {
                    @Published var announces = [Announce]()
                    var annoncePublisher: Published<[SecondHand3.Announce]>.Publisher{$announces}
                    
                    func checkForNewAnnounces() async {

                    }
                    
                    func checkForMoreAnnounces() async {
                        
                    }
                    
                    func getAnnouncesFiltered(text: String?, priceStart: Double, priceEnd: Double, category: String?, startDate: Date?, myAnnounceOnly: Bool, announceID: String?) async -> Result<[SecondHand3.Announce], Error> {
                        return .success([Announce.example, Announce.example, Announce.example])
                    }
                }
                
                sut.announceRepo = AnnounceRepoMock()
                sut.suscribeToAnnounceRepoArray()
                
                sut.getAnnouncesFiltered(searchText: "test", priceStart: 0, priceEnd: 1000, category: "Game", startDate: Date())
                await expect(sut.announces).toEventually(haveCount(3))
            }
        }
        
        describe("getFavouriteFunc"){
            it("updates favourite announce array when favourite announces returned by Favourite Domaine"){
                let sut = AnnouncesListVM()
                
                
                class favouriteDomaineMock: FavouriteDomaineProtocol{
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        return [Announce.example, Announce.example, Announce.example, Announce.example]
                    }
                    
                    func addAnnounceToFavorite(announceID: String) async {
                        
                    }
                    
                    func removeFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                    
                    func isAnnounceAFavourite(announce: SecondHand3.Announce) async -> Bool {
                        return false // not tested in this test
                    }
                    
                    @Published var favouriteAnnounces = [Announce]()
                    var favourites: Published<[SecondHand3.Announce]>.Publisher{$favouriteAnnounces}
                    
                    func AddOrRemoveFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                }
                
                sut.favouriteDomaine = favouriteDomaineMock()
                sut.getFavourite()
                await expect(sut.favourites).toEventually(haveCount(4))
                
            }
        }
        
        describe("isAFavouriteAnnounce"){
            it("returns true if announce is part of Favourite announce array"){
                let sut = AnnouncesListVM()
                
                
                class favouriteDomaineMock: FavouriteDomaineProtocol{
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        
                        var announce1 = Announce.example
                        announce1.id = "ID1"
                        
                        var announce2 = Announce.example
                        announce2.id = "ID2"
                        
                        var announce3 = Announce.example
                        announce3.id = "ID3"
                        return [announce1, announce2, announce3]
                    }
                    
                    func addAnnounceToFavorite(announceID: String) async {
                        
                    }
                    
                    func removeFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                    
                    func isAnnounceAFavourite(announce: SecondHand3.Announce) async -> Bool {
                        return false // not tested in this test
                    }
                    
                    @Published var favouriteAnnounces = [Announce]()
                    var favourites: Published<[SecondHand3.Announce]>.Publisher{$favouriteAnnounces}
                    
                    func AddOrRemoveFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                }
                
                sut.favouriteDomaine = favouriteDomaineMock()
                sut.getFavourite()
                await expect(sut.favourites).toEventually(haveCount(3))
                expect(sut.isAFavouriteAnnounce(announceId: "ID3")) ==  true
                
            }
        }
        describe("AddOrRemoveFromFavourite"){
            it("adds to favourite array if favourite Domaine adds it to favourite announce publisher"){
                let sut = AnnouncesListVM()
                
                
                class favouriteDomaineMock: FavouriteDomaineProtocol{
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        return favouriteAnnounces

                    }
                    
                    func addAnnounceToFavorite(announceID: String) async {
                        
                    }
                    
                    func removeFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                    
                    func isAnnounceAFavourite(announce: SecondHand3.Announce) async -> Bool {
                        return false // not tested in this test
                    }
                    
                    @Published var favouriteAnnounces = [Announce]()
                    var favourites: Published<[SecondHand3.Announce]>.Publisher{$favouriteAnnounces}
                    
                    func AddOrRemoveFromFavourite(announce: SecondHand3.Announce) async {
                        self.favouriteAnnounces.append(announce)
                    }
                }
                
                sut.favouriteDomaine = favouriteDomaineMock()
                sut.getFavourite()
                
                var announceToAddAsFav = Announce.example
                announceToAddAsFav.id = "ID4"
                sut.AddOrRemoveFromFavourite(announce:announceToAddAsFav)
                await expect(sut.favourites).toEventually(contain(announceToAddAsFav))
                
            }
            
            it("removes from favourite array if favourite Domaine removes it from favourite announce publisher"){
                let sut = AnnouncesListVM()
                
                
                class favouriteDomaineMock: FavouriteDomaineProtocol{
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        return favouriteAnnounces

                    }
                    
                    func addAnnounceToFavorite(announceID: String) async {
                        
                    }
                    
                    func removeFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                    
                    func isAnnounceAFavourite(announce: SecondHand3.Announce) async -> Bool {
                        return false // not tested in this test
                    }
                    
                    @Published var favouriteAnnounces: [Announce] = [Announce.example]
                    var favourites: Published<[SecondHand3.Announce]>.Publisher{$favouriteAnnounces}
                    
                    func AddOrRemoveFromFavourite(announce: SecondHand3.Announce) async {
                        self.favouriteAnnounces.removeAll(where: {$0.id == "example"})
                    }
                }
                
                sut.favouriteDomaine = favouriteDomaineMock()
                sut.getFavourite()
                await expect(sut.favourites).toEventually(contain(Announce.example))
                
                let announceToRemoveFromFav = Announce.example
                sut.AddOrRemoveFromFavourite(announce:announceToRemoveFromFav)
                await expect(sut.favourites).toEventually(beEmpty())
                
            }
        }
    }
    
}
