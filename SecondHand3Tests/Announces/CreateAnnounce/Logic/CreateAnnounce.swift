//
//  CreateAnnounce.swift
//  SecondHand3Tests
//
//  Created by Benjamin Szakal on 02/12/22.
//
@testable import SecondHand3
import Quick
import Nimble
import XCTest

class CreateAnnounceSpec: QuickSpec {
    
    override func spec() {
        
        describe("CreateAnnounceFunc") {
            
            context("when user is loggedOut") {
                it("doesn't call create Announce function in DataSourceService"){
                    let sut = CreateAnnounce()
                    
                    class CreateAnnounceFirebaseMock: CreateAnnounceFirebaseProtocol {
                        enum ErrorType: Error{
                            case userNotLoggedIn
                        }
                        
                        func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error> {
                            fail()
                            return .failure(ErrorType.userNotLoggedIn)
                        }
                        
                        func getuserUID() async -> Result<String, Error> {
                             return .failure(ErrorType.userNotLoggedIn)
                        }
                        
                        func addAnnounce(announce: SecondHand3.Announce) -> Result<Bool, Error> {
                            return .failure(ErrorType.userNotLoggedIn)
                        }
                    }
                    
                    
                    sut.createAnnounceFirebase = CreateAnnounceFirebaseMock()
                    
                   let result = await sut.createAnnounce(title: "", description: "", price: 0, category: "", size: "", condition: "", deliveryType: "", address: "", images: [Data()])
        
                    switch result {
                    case .success(_):
                        fail()
                    case .failure(_):
                        return
                    }
                    
                }
            }
            
            context("when user is logged In") {
                it("it calls create Announce function in DataSourceService"){
                    let sut = CreateAnnounce()
                    
                    class CreateAnnounceFirebaseMock: CreateAnnounceFirebaseProtocol {
                        var hasbeenran = false
                        enum ErrorType: Error{
                            case userNotLoggedIn
                        }
                        
                        func uploadImageStorage(photosData: [Data]) async -> Result<[String], Error> {
                            
                            return .success(["Testurl", "Testurl"])
                        }
                        
                        func getuserUID() async -> Result<String, Error> {
                            return .success("Ok")
                        }
                        
                        func addAnnounce(announce: SecondHand3.Announce) -> Result<Bool, Error> {
                            return .success(true)
                        }
                    }
                    
                    
                    sut.createAnnounceFirebase = CreateAnnounceFirebaseMock()
                    
                   let result = await sut.createAnnounce(title: "", description: "", price: 0, category: "", size: "", condition: "", deliveryType: "", address: "", images: [Data()])

                    switch result {
                    case .success(_):
                        return
                    case .failure(_):
                        fail()
                    }
                    
                }
            }
            
        }
    }
}
