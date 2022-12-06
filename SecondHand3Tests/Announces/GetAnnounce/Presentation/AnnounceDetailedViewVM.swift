//
//  AnnounceDetailedViewVM.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 03/12/22.
//
@testable import SecondHand3
import Quick
import Nimble
import XCTest

@MainActor
class AnnounceDetailedVSpec: QuickSpec {
    override func spec() {
        describe("isAFavouriteFunc") {
            
            it("it updates isFavourite published variable to true if favourite domain returns true"){
                let sut = AnnounceDetailedVM()
                
                class favouriteDomaineMock: FavouriteDomaineProtocol {
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        return [Announce.example] // not tested in this test
                    }
                    
                    func addAnnounceToFavorite(announceID: String) async {
                        
                    }
                    
                    func removeFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                    
                    func isAnnounceAFavourite(announce: SecondHand3.Announce) async -> Bool {
                        return true
                    }
                    
                    @Published var favouriteAnnounces = [Announce]()
                    var favourites: Published<[SecondHand3.Announce]>.Publisher{$favouriteAnnounces}
                    
                    func AddOrRemoveFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                }
                
                sut.favouriteDomaine = favouriteDomaineMock()
                sut.isAFavourite(announce: Announce.example)
                
                await expect(sut.isAFavourite).toEventually(beTrue())
            }
        }
        describe("AddOrRemoveFromFavouriteFunc") {
            
            it("change isAFavourite published variable to false if favourite Domaine removes it from favourite announce publisher"){
                let sut = AnnounceDetailedVM()
                
                class favouriteDomaineMock: FavouriteDomaineProtocol{
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        return favouriteAnnounces //not tested in this test

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
                sut.AddOrRemoveFromFavourite(announce: Announce.example)
                
                await expect(sut.isAFavourite).toEventually(beFalse())
            }
            
            it("change isAFavourite published variable to true if it is in favourite Domaine announce publisher"){
                let sut = AnnounceDetailedVM()
                
                class favouriteDomaineMock: FavouriteDomaineProtocol{
                    func getFavouriteAnnounce() async -> [SecondHand3.Announce] {
                        return favouriteAnnounces //not tested in this test

                    }
                    
                    func addAnnounceToFavorite(announceID: String) async {
                        
                    }
                    
                    func removeFromFavourite(announce: SecondHand3.Announce) async {
                        
                    }
                    
                    func isAnnounceAFavourite(announce: SecondHand3.Announce) async -> Bool {
                        return self.favouriteAnnounces.contains(where: {$0 == announce})
                    }
                    
                    @Published var favouriteAnnounces = [Announce]()
                    var favourites: Published<[SecondHand3.Announce]>.Publisher{$favouriteAnnounces}
                    
                    func AddOrRemoveFromFavourite(announce: SecondHand3.Announce) async {
                        self.favouriteAnnounces.append(announce)
                    }
                }
                
                sut.favouriteDomaine = favouriteDomaineMock()
                sut.AddOrRemoveFromFavourite(announce: Announce.example)
                
                await expect(sut.isAFavourite).toEventually(beTrue())
            }
        }
        
        describe("getUserDetailsForAnnounceFunc"){
            it("updates user profile for announce published variable when value returned from User profile domaine"){
                let sut = AnnounceDetailedVM()
                
                class GetUserProfileMock: GetUserProfileProtocol {
                    func getUserProfile() async -> Result<SecondHand3.UserProfile, Error> {
                        return .failure("Error" as! Error) // not used in this test
                    }
                    
                    func getEmailAddress() async -> Result<String, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserID() async -> Result<String, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserProfileForAnnounce(announce: SecondHand3.Announce) async -> Result<SecondHand3.UserProfile, Error> {
                        return .success(UserProfile(id: "test", firstName: "Benjamin", lastName: "Szakal", pseudo: "Zac", emailAddress: "benjamin.szakal1@gmail.com", address: "6 Allee Francois Villon, 38130, Echirolles", profilePictureUrlStr: ""))
                    }
                    
                    func getUserProfileForUserId(userID: String) async -> Result<SecondHand3.UserProfile, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserProfileOrPrepareNewOne() async -> Result<SecondHand3.UserProfile, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    
                }
                
                sut.getUserDomaine = GetUserProfileMock()
                sut.getUserDetailsForAnnounce(announce: Announce.example)
                
                await expect(sut.userProfileForAnnounce.id).toEventually(equal("test"))
            }
        }
        
        describe("getCurrentUserDetails") {
            it("updates current user profile published variable when value returned from User profile domaine"){
                let sut = AnnounceDetailedVM()
                
                class GetUserProfileMock: GetUserProfileProtocol {
                    func getUserProfile() async -> Result<SecondHand3.UserProfile, Error> {
                        return .success(UserProfile(id: "test", firstName: "Benjamin", lastName: "Szakal", pseudo: "Zac", emailAddress: "benjamin.szakal1@gmail.com", address: "6 Allee Francois Villon, 38130, Echirolles", profilePictureUrlStr: ""))
                    }
                    
                    func getEmailAddress() async -> Result<String, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserID() async -> Result<String, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserProfileForAnnounce(announce: SecondHand3.Announce) async -> Result<SecondHand3.UserProfile, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserProfileForUserId(userID: String) async -> Result<SecondHand3.UserProfile, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    func getUserProfileOrPrepareNewOne() async -> Result<SecondHand3.UserProfile, Error> {
                        return .failure("Error" as! Error)
                    }
                    
                    
                }
                
                sut.getUserDomaine = GetUserProfileMock()
                sut.getCurrentUserDetails()
                
                await expect(sut.currentUserProfile.id).toEventually(equal("test"))
            }
        }
    }
}
