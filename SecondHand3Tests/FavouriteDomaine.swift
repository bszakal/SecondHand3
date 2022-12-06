//
//  FavouriteDomaine.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 04/12/22.
//
@testable import SecondHand3
import Quick
import Nimble
import XCTest
import Combine


class FavouriteDomaineSpec: QuickSpec{
    
    override func spec() {
        describe("getFavouriteAnnounce") {
            it("Updates favourite Announce array publisher when favourites are returned from Data Source and return favourite announces"){
                let sut = FavouriteDomaine()
                
                class FirebaseFavouriteMock: FirebaseFavouriteProtocol{
                    func getuserUID() async -> Result<String, Error> {
                        return .success("testUserID")
                    }
                    
                    func addAnnounceToFavourite(favourite: SecondHand3.Favourite) {
                         // not used in this test
                    }
                    
                    func getFavouriteForUser(userId: String) async -> Result<([SecondHand3.Favourite]), Error> {
                        return .success([Favourite(userID: "testUserID", announceID: "testAnnounceID")])
                    }
                    
                    func getAnnouncesForIds(announcesId: [String]) async -> Result<([SecondHand3.Announce]), Error> {
                        return .success([Announce.example])
                    }
                    
                    func removeFromFavorite(favourite: SecondHand3.Favourite) async {
                         // not used in this test
                    }
                }
                
                sut.firebaseFavourite = FirebaseFavouriteMock()
                let announces = await sut.getFavouriteAnnounce()
                expect(announces).to(haveCount(1))
                
                //create a variable that suscribe to FavouriteDomain publisher of announces
                var favourites = [Announce]()
                var cancellable = Set<AnyCancellable>()
                sut.favourites
                    .subscribe(on: DispatchQueue.main)
                    .sink{ newValue in favourites  = newValue}
                    .store(in: &cancellable)
                
                await expect(favourites).toEventually(haveCount(1))
            }
        }
        
        describe("isAnnounceAFavouriteFunc") {
            it("returns true if announce is in Favourite Announces array"){
                let sut = FavouriteDomaine()
                
                class FirebaseFavouriteMock: FirebaseFavouriteProtocol{
                    func getuserUID() async -> Result<String, Error> {
                        return .success("testUserID")
                    }
                    
                    func addAnnounceToFavourite(favourite: SecondHand3.Favourite) {
                         // not used in this test
                    }
                    
                    func getFavouriteForUser(userId: String) async -> Result<([SecondHand3.Favourite]), Error> {
                        return .success([Favourite(userID: "testUserID", announceID: "testAnnounceID")])
                    }
                    
                    func getAnnouncesForIds(announcesId: [String]) async -> Result<([SecondHand3.Announce]), Error> {
                        return .success([Announce(id: "example", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])])
                    }
                    
                    func removeFromFavorite(favourite: SecondHand3.Favourite) async {
                         // not used in this test
                    }
                }
                
                sut.firebaseFavourite = FirebaseFavouriteMock()
                let announces = await sut.getFavouriteAnnounce()
                
                let announce = Announce(id: "example", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])
                
                let notAFavAnnounce = Announce(id: "NotAFav", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])
                
                let isAFav = await sut.isAnnounceAFavourite(announce: announce)
                expect(isAFav) == true
                
                let isAFav2 = await sut.isAnnounceAFavourite(announce: notAFavAnnounce)
                expect(isAFav2) == false
            }
        }
        
        describe("AddOrRemoveFromFavouriteFunc") {
            it("it calls removeFromFavourite func in dataSource layer when func is call and announce is already in favourite"){
                let sut = FavouriteDomaine()
                
                class FirebaseFavouriteMock: FirebaseFavouriteProtocol{
                    
                    var removeFromFavouriteFuncHasBeenCalled = false
                    
                    func getuserUID() async -> Result<String, Error> {
                        return .success("testUserID")
                    }
                    
                    func addAnnounceToFavourite(favourite: SecondHand3.Favourite) {
                         // not used in this test
                    }
                    
                    func getFavouriteForUser(userId: String) async -> Result<([SecondHand3.Favourite]), Error> {
                        return .success([Favourite(userID: "testUserID", announceID: "example")])
                    }
                    
                    func getAnnouncesForIds(announcesId: [String]) async -> Result<([SecondHand3.Announce]), Error> {
                        return .success([Announce(id: "example", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])])
                    }
                    
                    func removeFromFavorite(favourite: SecondHand3.Favourite) async {
                        removeFromFavouriteFuncHasBeenCalled = true
                    }
                }
                
                let firebaseFavouriteMock = FirebaseFavouriteMock()
                sut.firebaseFavourite = firebaseFavouriteMock
                let announces = await sut.getFavouriteAnnounce()
                
                let announceToRemove = Announce(id: "example", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])
                
                await sut.AddOrRemoveFromFavourite(announce: announceToRemove)
                expect(firebaseFavouriteMock.removeFromFavouriteFuncHasBeenCalled) == true
            }
            
            it("it calls addAnnounceToFavourite func in dataSource layer if announce is not already in the favourite"){
                let sut = FavouriteDomaine()
                
                class FirebaseFavouriteMock: FirebaseFavouriteProtocol{
                    
                    var addToFavouriteFuncHasBeenCalled = false
                    
                    func getuserUID() async -> Result<String, Error> {
                        return .success("testUserID")
                    }
                    
                    func addAnnounceToFavourite(favourite: SecondHand3.Favourite) {
                         addToFavouriteFuncHasBeenCalled = true
                    }
                    
                    func getFavouriteForUser(userId: String) async -> Result<([SecondHand3.Favourite]), Error> {
                        return .success([Favourite(userID: "testUserID", announceID: "example")])
                    }
                    
                    func getAnnouncesForIds(announcesId: [String]) async -> Result<([SecondHand3.Announce]), Error> {
                        return .success([Announce(id: "example", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])])
                    }
                    
                    func removeFromFavorite(favourite: SecondHand3.Favourite) async {
                        // not used in this test
                    }
                }
                
                let firebaseFavouriteMock = FirebaseFavouriteMock()
                sut.firebaseFavourite = firebaseFavouriteMock
                let announces = await sut.getFavouriteAnnounce()
                
                let announceToAdd = Announce(id: "DifferentAnnounce", title: "Army of Two", description: "Good game", price: 12, category: "Game", size: "n/a", condition: "Very Good", deliveryType: "Collection", address: "8 route du Pavillon, 38760, Varces", userUID: "jcmNLTViDBYZSBXKfAKRIISsZLu1", imageRefs: [""])
                
                await sut.AddOrRemoveFromFavourite(announce: announceToAdd)
                expect(firebaseFavouriteMock.addToFavouriteFuncHasBeenCalled) == true
            }

        }
    }
}
