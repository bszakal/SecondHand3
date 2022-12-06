//
//  CreateAnnounceVM.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 04/12/22.
//
@testable import SecondHand3
import Nimble
import Quick
import Foundation

@MainActor
class CreateAnnounceVMSpec: QuickSpec{
    
    override func spec() {
        describe("getCategories") {
            let sut = CreateAnnounceVM()
            
            it("Updates categories property when results returned from DataSource"){
                class FirebaseCategoriesMock: FirebaseCategoriesProtocol{
                    func getCategories() async -> Result<[SecondHand3.Category], Error> {
                        .success([Category(Name: "Books", Image: "https://thumbs.dreamstime.com/z/open-book-19523116.jpg")])
                    }
                }
                
                sut.fetcher = FirebaseCategoriesMock()
                sut.getCategories()
                
                expect(sut.categories).to(beEmpty())
                await expect(sut.categories).toEventually(haveCount(1))
            }
        }
        
        describe("uploadAnnounce") {
            let sut = CreateAnnounceVM()
            
            it("calls CreateAnnounce func from the CreateAnnounce logic layer"){
                class CreateAnnounceLogicMock: CreateAnnounceProtocol{
                    
                    var createAnnounceHasBeenCalled = false
                    
                    func createAnnounce(title: String, description: String, price: Double, category: String, size: String, condition: String, deliveryType: String, address: String, images: [Data]) async -> Result<Bool, Error> {
                        createAnnounceHasBeenCalled = true
                        return .success(true)
                    }
                }
                let createAnnounceLogicMock = CreateAnnounceLogicMock()
                sut.createAnnounce = createAnnounceLogicMock
                let res = await sut.uploadAnnounce(title: "", description: "", price: 10, category: "", condition: "", deliveryType: "", address: "", images: [UIImage()])
                
                switch res {
                case .success(_):
                    //check Create Announce func from the Create Announce logic is called
                    expect(createAnnounceLogicMock.createAnnounceHasBeenCalled) == true
                case .failure(_):
                    fail()
                }
              
            }
        }
    }
}
