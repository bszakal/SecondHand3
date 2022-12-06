//
//  AnnounceView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 01/11/22.
//

import Nuke
import NukeUI
import SwiftUI

struct AnnounceView: View {

    
    @StateObject var announcesListVM = AnnouncesListVM()

    var isPartOfMainView: Bool = false
    var title: String = "Latest Announces"
    
    @State var isSearchFiltered = false
    @State var searchText: String = ""
    @State var category: String = "Any"
    @State var minPrice: Double = 0
    @State var maxPrice: Double = 1000
    @State var noOlderThanDate: Date = Calendar.current.date(byAdding: .day, value: -300, to: Date()) ?? Date()
   
    
    var body: some View {

            VStack(alignment:.leading, spacing: 8){
                Text(title)
                    .foregroundColor(.primary)
                    .font(.title)
                
                filtersApplied

                if isPartOfMainView == false {
                    ScrollView(showsIndicators:false){
                        gridViewForAnnounces(announcesListVM: announcesListVM, isSearchFiltered: isSearchFiltered, isTempData: false, announces: announcesListVM.announces)
                        
                    }
                    .refreshable {
                        if isSearchFiltered == false {
                            announcesListVM.CheckNewAnnounces()
                        } else {
                            announcesListVM.getAnnouncesFiltered(searchText: searchText, priceStart: minPrice, priceEnd: maxPrice, category: category, startDate: noOlderThanDate)
                        }
                        
                    }
                } else {
                    if announcesListVM.useTempData{
                        gridViewForAnnounces(announcesListVM: announcesListVM, isSearchFiltered: isSearchFiltered, isTempData: true, announces: announcesListVM.tempData)
                    } else {
                        gridViewForAnnounces(announcesListVM: announcesListVM, isSearchFiltered: isSearchFiltered, isTempData: false, announces: announcesListVM.announces)
                    }
                }
            }
            .padding(.horizontal)

        .onAppear{
            announcesListVM.suscribeToAnnounceRepoArray()
            // due to filtering limitation with Firebase Query there is no pagination if the search is filtered hence why different function
            if isSearchFiltered == true {
                announcesListVM.getAnnouncesFiltered(searchText: searchText, priceStart: minPrice, priceEnd: maxPrice, category: category, startDate: noOlderThanDate)
            } else {
                announcesListVM.CheckNewAnnounces()
            }
            
            announcesListVM.getFavourite()
        }
        
 
    }
    
    
    struct gridViewForAnnounces: View {

        @ObservedObject var announcesListVM: AnnouncesListVM
        let isSearchFiltered: Bool
        let isTempData: Bool
        let announces: [Announce]
        
        var body: some View{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))], spacing: 10){
                ForEach(announces) { announce in
                    SingleAnnounceView(announce: announce,announcesListVM: announcesListVM)
                        .frame(height: 350)
                        .onAppear{
                            if announcesListVM.isLastAnnounce(announce: announce)  && !isTempData {
                                if isSearchFiltered == false {
                                    announcesListVM.checkForMoreAnnouces()
                                }
                                
                            }
                        }
                }
            }
        }
    }
    
    var filtersApplied: some View {
        ScrollView(.horizontal){
            HStack{
                
                isSearchFiltered ? Text("Filters:") : nil
                Group{
                    if isSearchFiltered == true {
                        
                        category != "Any" ? Text("Category: \(category)") : nil
                        minPrice > 0 ? Text("Min Price: \(minPrice, format: .number)") : nil
                        maxPrice < 1000 ? Text("Max Price: \(maxPrice, format: .number)") : nil
                        
                    }
                }
                .padding(7)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}




struct AnnounceView_Previews: PreviewProvider {
    static var previews: some View {
        AnnounceView(isSearchFiltered: true, category: "Game")
            .environmentObject(LoginState())
    }
}
