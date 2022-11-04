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
    @State private var nbreOfAnnouncesDisplayed = 0
    var isPartOfMainView: Bool = false
    var title: String = "Latest Announces"
    
    @State var showFilterView = false
    @State var isSearchFiltered = false
    @State private var searchText: String = ""
    @State var category: String = "Any"
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 1000
    @State private var noOlderThanDate: Date = Calendar.current.date(byAdding: .day, value: -300, to: Date()) ?? Date()
    
    var body: some View {
        
        VStack{
            if isSearchFiltered == true {
             searchBar(searchText: $searchText)
                    .onTapGesture {
                        showFilterView = true
                    }
            }
            
            VStack(alignment:.leading, spacing: 8){
                Text(title)
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                
                if isPartOfMainView == false {
                    ScrollView(showsIndicators:false){
                        gridViewAnnounces
                        
                    }
                    .refreshable {
                        if isSearchFiltered == false {
                            announcesListVM.CheckNewAnnounces()
                        } else {
                            announcesListVM.getAnnouncesFiltered(searchText: searchText, priceStart: minPrice, priceEnd: maxPrice, category: category, startDate: noOlderThanDate)
                        }
                        
                    }
                } else {
                    gridViewAnnounces
                }
            }
            .padding(.horizontal)
        }
            .fullScreenCover(isPresented: $showFilterView, onDismiss: {
                showFilterView = false
                announcesListVM.getAnnouncesFiltered(searchText: searchText, priceStart: minPrice, priceEnd: maxPrice, category: category, startDate: noOlderThanDate)
            }){
                SearchFilterView(searchText: $searchText, category: $category, minPrice: $minPrice, maxPrice: $maxPrice, noOlderThanDate: $noOlderThanDate)
            }
        
        .onAppear{
            if isSearchFiltered == true {
                announcesListVM.getAnnouncesFiltered(searchText: searchText, priceStart: minPrice, priceEnd: maxPrice, category: category, startDate: noOlderThanDate)
            } else {
                announcesListVM.CheckNewAnnounces()
            }
        }
    }
    
    var gridViewAnnounces: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))], spacing: 10){
            ForEach(announcesListVM.announces) { announce in
                SingleAnnounceView(announce: announce)
                    .frame(height: 350)
                    .onAppear{
                        if announcesListVM.isLastAnnounce(announce: announce) {
                            if isSearchFiltered == false {
                                announcesListVM.checkForMoreAnnouces()
                            }
                            
                        }
                    }
            }
        }
    }
}

struct SingleAnnounceView: View {
    
    let announce: Announce
    
    var body: some View{
        
        VStack{
            VStack(alignment:.leading){
                ZStack{
                    photoView2(imageUrlsString: announce.imageRefs)
                }
                .padding(.bottom, 2)
                Text(announce.title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(announce.price, format: .currency(code: "EUR"))
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                Text(announce.city_PostCode)
                    .foregroundColor(.secondary)
                HStack{
                    Text(announce.lastUpdatedAt ?? Date(), format: .dateTime.day().month())
                    Text("a")
                    Text(announce.lastUpdatedAt ?? Date(), format: .dateTime.hour().minute())
                }
                .foregroundColor(.secondary)
            }
        }
    }

    
    struct photoView2: View {
        let imageUrlsString: [String]
        @State private var imageShowedIndex: Int = 0
        @State private var dragAmount = 0.0
        
        var body: some View{
            ZStack(alignment:.bottom){
                LazyImage(source: imageUrlsString[imageShowedIndex]) { state in
                    if let image = state.image {
                        image
                    } else if state.error != nil {
                        Color.red
                    } else {
                        ZStack{
                            Color.gray
                            Image(systemName: "photo.artframe")
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                photoNbreIndicator(imageNbre: imageShowedIndex, totalNbre: imageUrlsString.count - 1)
                    .foregroundColor(.white)
                    .padding(.bottom)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .gesture(
            DragGesture()
                .onEnded({ value in
                    if value.predictedEndLocation.x < value.startLocation.x {
                        if imageShowedIndex != imageUrlsString.count - 1 {
                            withAnimation{
                                imageShowedIndex += 1
                            }
                        }
                    } else {
                        if imageShowedIndex != 0 {
                            withAnimation{
                                imageShowedIndex -= 1
                            }
                        }
                    }
                })
            )
        }
            
    }
    
    struct photoNbreIndicator: View {
        
        let imageNbre: Int
        let totalNbre: Int
        
        var body: some View{
            HStack{
                
                ForEach(0...totalNbre, id:\.self) {nbre in
                    if nbre == imageNbre {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 10))
                    } else {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                    }
                }
            }
        }
    }
    
}

struct AnnounceView_Previews: PreviewProvider {
    static var previews: some View {
        AnnounceView()
    }
}
