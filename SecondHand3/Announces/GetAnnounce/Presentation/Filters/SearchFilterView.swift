//
//  SearchFilterView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 03/11/22.
//

import SwiftUI

struct SearchFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var searchfilterVM = SearchFilterVM()
    
    @FocusState private var searchBarFocus
    
    @Binding var searchText: String
    @Binding var category: String
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    @Binding var noOlderThanDate: Date
    let callbackIfSearchPushed: ()-> Void
    let callbackIfCancelled: ()-> Void
    
    //animation related
    @State private var individualFiltersOpacity: CGFloat = 0
    @State private var pricesFilterOpacity: CGFloat = 0
    @State private var buttonOpacity: CGFloat = 0
    @State private var dismissXmarkOpacity: CGFloat = 0
    @State private var categoryOffset: CGFloat = 10
    @State private var dateOffset: CGFloat = 10
    @State private var pricesFilterOffset: CGFloat = 10
    @State private var buttonOffset: CGFloat = 10
    
    @State private var fadeOutOnDismiss = false
    
    var body: some View {
        
        
        GeometryReader{geo in
            
            background
            
            HStack{
                Image(systemName: "xmark")
                    .padding(5)
                    .background(Circle().foregroundColor(.white))
            }
            .opacity(dismissXmarkOpacity).animation(.linear(duration: 1), value: dismissXmarkOpacity)
            .onTapGesture {
                Task{
                    animationOnDisappear()
                    withAnimation{
                        fadeOutOnDismiss = true
                    }
                    try await Task.sleep(nanoseconds: 500_000_000)
                    callbackIfCancelled()
                    dismiss()
                }
            }
            .offset(y: -5)
            .padding(.horizontal)
            
            searchBar(searchText: $searchText)
                .focused($searchBarFocus)
                .padding(.vertical)
                .offset(y:10)
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal)
            
            
            categoryFilter
                .padding(.horizontal)
                .frame(minHeight: 50)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y:categoryOffset).animation(.linear(duration: 0.5), value: categoryOffset)
                .padding(.horizontal)
            
            dateFilter
                .padding(.horizontal)
                .frame(minHeight: 50)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y:dateOffset).animation(.linear(duration: 0.5), value: dateOffset)
                .opacity(individualFiltersOpacity).animation(.linear(duration: 1), value: individualFiltersOpacity)
                .padding(.horizontal)
            
            VStack{
                priceFilters
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical)
            .offset(y: pricesFilterOffset).animation(.linear(duration: 0.5), value: pricesFilterOffset)
            .opacity(pricesFilterOpacity).animation(.linear(duration: 2), value: pricesFilterOpacity)
            .padding(.horizontal)
            
            
            
            HStack{
                Spacer()
                Button("Search") {
                    Task{
                        animationOnDisappear()
                        withAnimation{
                            fadeOutOnDismiss = true
                        }
                        try await Task.sleep(nanoseconds: 500_000_000)
                        callbackIfSearchPushed()
                        dismiss()
                    }
                }
                .foregroundColor(.black)
                .font(.title2)
                .fontWeight(.bold)
                .underline()
                .padding(8)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y: buttonOffset).animation(.linear(duration: 0.5), value: buttonOffset)
                .opacity(buttonOpacity).animation(.linear(duration: 2.5), value: buttonOpacity)
                .padding(.horizontal)
            }
            Spacer()
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear{
            animationOnAppear()
        }
        .opacity(fadeOutOnDismiss ? 0 : 1).animation(.linear(duration: 0.5), value: fadeOutOnDismiss)
        
    }
    
    func animationOnAppear() {
        searchBarFocus = false
        searchfilterVM.getCategories()
        Task{
            withAnimation{
                individualFiltersOpacity = 1
                dismissXmarkOpacity = 1
                categoryOffset = 100
                dateOffset = 160
            }
            try await Task.sleep(nanoseconds:300_000_000)
            withAnimation{
                pricesFilterOpacity = 1
                pricesFilterOffset = 230
            }
            try await Task.sleep(nanoseconds:300_000_000)
            withAnimation{
                buttonOpacity = 1
                buttonOffset = 450
            }
        }
    }
    
    func animationOnDisappear() {
        searchBarFocus = false
            withAnimation{
                individualFiltersOpacity = 0
                dismissXmarkOpacity = 0
                categoryOffset = 0
                dateOffset = 0
                pricesFilterOpacity = 0
                pricesFilterOffset = 0
                
                buttonOpacity = 0
                buttonOffset = 0
            
        }
    }
    
    var title: some View {
        VStack{
            ZStack{
                Text("Filters")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack{
                    Image(systemName: "xmark")
                        .padding(.leading)
                        .font(.title3)
                        .foregroundColor(.white)
                        .onTapGesture {
                            searchText = ""
                            dismiss()
                        }
                        
                    Spacer()
                }
            }
            .font(.title2)
            .padding(.top, 20)
            dividerCustom
            
        }
        .background(.gray).opacity(1)
    }
    
    var categoryFilter: some View {
        HStack{
            Text("Category:")
            Spacer()
            Picker("Category:", selection: $category) {
                Text("Any")
                    .tag("Any")
                ForEach(searchfilterVM.categories) { cat in
                    Text(cat.Name)
                        .tag(cat.Name)
                }
            }
            .tint(.primary)
        }
    }
    
 @ViewBuilder   var dateFilter: some View {

        DatePicker("Starting from:", selection: $noOlderThanDate, displayedComponents: .date)
         .datePickerStyle(.compact)
    }
    
 @ViewBuilder   var priceFilters: some View {
        HStack{
            Text("Min price:")
            Spacer()
            Text(minPrice, format: .number)
                .fontWeight(.semibold)
        }
        Slider(value: $minPrice, in: 0...1000, step: 1)
         .tint(.black)
        
        HStack{
            Text("Max price:")
            Spacer()
            Text(maxPrice, format: .number)
                .fontWeight(.semibold)
        }
        Slider(value: $maxPrice, in: 0...1000, step: 1)
         .tint(.black)
    }
    
   @ViewBuilder var background: some View {
        Color.black.opacity(0.15)
            .ignoresSafeArea()
        Image("MainScreen")
            .resizable()
            .scaledToFill()
            .blur(radius: 15)
            .opacity(0.3)
    }
}



struct searchBar: View {
    
    @Environment (\.dismiss) var dismiss
    @Binding var searchText: String
    
    var body: some View{
        
        ZStack(alignment:.trailing){
            TextField("Search", text: $searchText)
                .padding()
                .frame(maxHeight: 50)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .foregroundColor(.primary)
                
                
            if searchText != "" {
                Image(systemName: "x.circle.fill")
                    .padding(.horizontal, 30)
                    .onTapGesture {
                        searchText = ""
                    }
            } else {
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal, 30)
                    
            }
        }
        
        
    }
}


struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterView(searchText: .constant(""), category: .constant("Any"), minPrice: .constant(0), maxPrice: .constant(1000), noOlderThanDate: .constant(Date()), callbackIfSearchPushed:({})) {}
    }
}
