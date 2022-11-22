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
        
        //NavigationStack{
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
                                    imageLoaderCategory(imageUrlString: cat.Image)
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
        //}
        .onAppear{
            categoriesVM.getCategories()
        }
        
    }
    
    
    struct imageLoaderCategory: View {
        
        let imageUrlString: String
        var body: some View {
            LazyImage(source: imageUrlString) { state in
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
            .frame(width: 200, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct listOfCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        listOfCategoriesView()
    }
}
