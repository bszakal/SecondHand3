//
//  HomePageView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 04/11/22.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var searchText: String = ""
    
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    NavigationLink {
                        AnnounceView(isPartOfMainView: false, showFilterView: true, isSearchFiltered: true)
                    } label: {
                        searchBar(searchText: $searchText)
                    }
                    
                    searchBar(searchText: $searchText)
                    
                    listOfCategoriesView()
                        .frame(height: 220)
           
                    AnnounceView(isPartOfMainView: true)
                }
                
            }
        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
