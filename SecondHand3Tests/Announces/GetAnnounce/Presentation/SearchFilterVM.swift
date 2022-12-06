//
//  SearchFilterVM.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 04/12/22.
//
@testable import SecondHand3
import Nimble
import Quick
import XCTest

@MainActor
class SearchFilterVMSpec: QuickSpec{
    
    override func spec() {
        describe("getCategoriesFunc") {
            let sut = CategoriesVM()
            
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
    }
}
