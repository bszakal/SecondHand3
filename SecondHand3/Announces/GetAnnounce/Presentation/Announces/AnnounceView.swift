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
    
    @State var showFilterView = false
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
                    if announcesListVM.useTempData{
                        gridViewAnnouncesTempData
                    } else {
                        gridViewAnnounces
                    }
                }
            }
            .padding(.horizontal)
            //.background(.ultraThinMaterial)

        .onAppear{
            if isSearchFiltered == true {
                announcesListVM.getAnnouncesFiltered(searchText: searchText, priceStart: minPrice, priceEnd: maxPrice, category: category, startDate: noOlderThanDate)
            } else {
                announcesListVM.CheckNewAnnounces()
            }
            announcesListVM.getFavourite()
        }
        
 
    }
    
    var gridViewAnnounces: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))], spacing: 10){
            ForEach(announcesListVM.announces) { announce in
                SingleAnnounceView(announce: announce,announcesListVM: announcesListVM)
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
    var gridViewAnnouncesTempData: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))], spacing: 10){
            ForEach(announcesListVM.tempData) { announce in
                SingleAnnounceView(announce: announce,announcesListVM: announcesListVM)
                    .frame(height: 350)
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

struct SingleAnnounceView: View {
    
    let announce: Announce
    @ObservedObject var announcesListVM: AnnouncesListVM
    
    @State private var scaleEffectFavChange: Double = 1
    
    @EnvironmentObject var loginState: LoginState
    @State private var showLoginView = false
    
    
    var body: some View{
        
        VStack{
            VStack(alignment:.leading){
                ZStack(alignment:.topTrailing){
                    NavigationLink {
                        AnnounceDetailedView(announce: announce)
                    } label: {
                        photoView2(imageUrlsString: announce.imageRefs)
                    }

                    favouriteImageView
               
                }
                .padding(.bottom, 2)
               textView
            }
        }
        .sheet(isPresented: $showLoginView) {
            LoginView()
        }
    }

    var favouriteImageView: some View {
        Group{
            if announcesListVM.isAFavouriteAnnounce(announceId: announce.id ?? "") {
                Image(systemName: "heart.fill")
                    .contentShape(Rectangle())
                    .foregroundColor(.red)
                    .onTapGesture {
                        if loginState.isLoggedIn {
                            announcesListVM.removeFromFavourite(announce: announce)
                            Task{
                                scaleEffectFavChange = 2
                                try await Task.sleep(nanoseconds: 200_000_000)
                                scaleEffectFavChange = 1
                            }
                        } else {
                            showLoginView = true
                        }
                    }
                    
                    
            } else {
                Image(systemName: "heart")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if loginState.isLoggedIn{
                            announcesListVM.addToFavourite(announce: announce)
                            Task{
                                scaleEffectFavChange = 2
                                try await Task.sleep(nanoseconds: 200_000_000)
                                scaleEffectFavChange = 1
                            }
                        } else {
                            showLoginView = true
                        }
                    }
            }
        }
        .modifier(animatedFavChange(scaleEffectFav: scaleEffectFavChange))
            .padding()
    }
 
    var textView: some View {
        VStack(alignment:.leading){
            HStack(alignment:.top){
                VStack(alignment:.leading){
                    Text(announce.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(announce.price, format: .currency(code: "EUR"))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 1)
                    
                }
                .modifier(tempDataModifier(isTempata: announcesListVM.useTempData))
                Spacer()
                HStack(spacing:0){
                    Image(systemName: "star.fill")
                    Text(5, format: .number)
                }
                .padding(.trailing,2)
                .modifier(tempDataModifier(isTempata: announcesListVM.useTempData))
            }
            Text(announce.city_PostCode)
                .foregroundColor(.secondary)
                .modifier(tempDataModifier(isTempata: announcesListVM.useTempData))
            HStack{
                Text(announce.lastUpdatedAt ?? Date(), format: .dateTime.day().month())
                Text("a")
                Text(announce.lastUpdatedAt ?? Date(), format: .dateTime.hour().minute())
            }
            .foregroundColor(.secondary)
            .modifier(tempDataModifier(isTempata: announcesListVM.useTempData))
        }
        
    }

    
}
struct tempDataModifier: ViewModifier {
    let isTempata: Bool
    func body(content: Content) -> some View {
        if isTempata {
        content
                .overlay(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
        } else {
        content
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
                    Color.gray
                } else {
                    ZStack{
                        Color.gray
//                        Image(systemName: "photo.artframe")
//                            .foregroundColor(.white)
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
            if totalNbre == 0 {
                
            } else{
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
        AnnounceView(isSearchFiltered: true, category: "Game")
            .environmentObject(LoginState())
    }
}
