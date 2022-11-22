//
//  HomePageView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 04/11/22.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var searchText: String = ""
    @State var category: String = "Any"
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 1000
    @State private var noOlderThanDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    
    @State private var showFilterView = false
    @State private var showFilterSecondWay = false
    @State private var isfiletered = false
    @State private var imageBackgroundBlur: UIImage? = nil
    
    
    var body: some View {
        NavigationStack{
        
            if showFilterSecondWay == false {
                ScrollView{
                    VStack{
                        
                        searchBar(searchText: $searchText)
                            .padding(.horizontal)
                            .disabled(true)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                //showFilterView = true
                                withAnimation{
                                    showFilterSecondWay = true
                                }
                                isfiletered = false
                                imageBackgroundBlur = ImageRenderer(content: AnnounceView(isPartOfMainView: true)).uiImage
                            }
                        
                        if isfiletered == true {
                            
                            AnnounceView(showFilterView: false, isSearchFiltered: true, searchText: searchText, category: category, minPrice: minPrice, maxPrice: maxPrice, noOlderThanDate: noOlderThanDate)
                            
                        } else {
                            
                            listOfCategoriesView()
                                .frame(height: 220)
                            
                            AnnounceView(isPartOfMainView: true)
                        }
                        
                        
                        
                    }
                }
                .background(LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.3), .white]), startPoint: .top, endPoint: .trailing))
               
            } else {
                SearchFilterView(searchText: $searchText, category: $category, minPrice: $minPrice, maxPrice: $maxPrice, noOlderThanDate: $noOlderThanDate, callbackIfSearchPushed:({
                    isfiletered = true
                        showFilterSecondWay = false
                }), callbackIfCancelled: {
                    withAnimation(.linear(duration: 0.5)){
                        showFilterSecondWay = false
                    }
                })
            }
            
        }
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

