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
    
    var body: some View {
        
            VStack(spacing:20){
                VStack{
                    ZStack{
                        Text("Filters")
                            .font(.title2)
                        HStack{
                            Image(systemName: "xmark")
                                .font(.title2)
                                .padding(.leading)
                                .onTapGesture {
                                    dismiss()
                                }
                            Spacer()
                        }
                    }
                    dividerCustom
                        
                }
                
                searchBar(searchText: $searchText)
                    .focused($searchBarFocus)
                
                List{
                    Section{
                        Picker("Category:", selection: $category) {
                            Text("Any")
                                .tag("Any")
                            ForEach(searchfilterVM.categories) { cat in
                                Text(cat.Name)
                                    .tag(cat.Name)
                            }
                        }
                    }
                    Section{
                        HStack{
                            Text("Min price:")
                            Spacer()
                            Text(minPrice, format: .number)
                        }
                        Slider(value: $minPrice, in: 0...1000, step: 1)
                        HStack{
                            Text("Max price:")
                            Spacer()
                            Text(maxPrice, format: .number)
                        }
                        Slider(value: $maxPrice, in: 0...1000, step: 1)
                    }
                    Section{
                        DatePicker("Starting from:", selection: $noOlderThanDate, displayedComponents: .date)
                    }
                    
                }
                .frame(maxHeight: 270)
                .listStyle(.plain)
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke()
                }
                .padding(.horizontal)
                .padding(.bottom)
                HStack{
                    
                    Button("Search") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .font(.title2)
                    .background(.pink.opacity(0.6))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                Spacer()
                
            }
            .shadow(radius: 3)
        
        .onAppear{
            searchBarFocus.toggle()
            searchfilterVM.getCategories()
        }
    }
}

struct searchBar: View {
    
    @Environment (\.dismiss) var dismiss
    @Binding var searchText: String
    
    var body: some View{
        
        ZStack(alignment:.trailing){
            TextField("Search", text: $searchText)
                .padding()
                .background(RoundedRectangle(cornerRadius: 50).stroke())
                .foregroundColor(.primary)
                .padding(.horizontal)
            Image(systemName: "magnifyingglass")
                .padding(.horizontal, 40)
                .onTapGesture {
                    dismiss()
                }
        }
        
    }
}

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterView(searchText: .constant(""), category: .constant("Any"), minPrice: .constant(0), maxPrice: .constant(1000), noOlderThanDate: .constant(Date()))
    }
}
