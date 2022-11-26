//
//  listOfCategoriesView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 03/11/22.
//
import Nuke
import NukeUI
import SwiftUI

struct listOfCategoriesView: View {
    
    @StateObject var categoriesVM = CategoriesVM()
    
    var body: some View {
        
            VStack(alignment:.leading, spacing: 8){
                
                Text("Top Categories")
                    .foregroundColor(.primary)
                    .font(.title)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(categoriesVM.categories){ cat in
                            NavigationLink {
                                AnnounceView(isSearchFiltered: true, category: cat.Name)
                            } label: {
                                ZStack(alignment:.bottomLeading){
                                    
                                    photoView2(imageUrlsString: [cat.Image])
                                        .frame(width: 200, height: 150)
                                    
                                    Text(cat.Name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            }
                        }
                    }
                }
                
            }
            .padding(.leading)
        
        .onAppear{
            categoriesVM.getCategories()
        }
        
    }
}

struct listOfCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        listOfCategoriesView()
    }
}
