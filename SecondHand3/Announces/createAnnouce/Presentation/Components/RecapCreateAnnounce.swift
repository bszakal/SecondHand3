//
//  RecapCreateAnnounce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 20/11/22.
//

import SwiftUI

/*
 createAnnounceVM.uploadAnnounce(title: title, description: descrpition, price: price!, category: selectedCategory, condition: condition, deliveryType: deliveryType, address: fullAddress, images: uiPhotosArray)
 */

struct RecapCreateAnnounce: View {
    
    @ObservedObject var createAnnounceVM: CreateAnnounceVM
    
    @State var title: String
    @State var description: String
    @State var price: Double
    @State var category: String
    @State var condition: String
    @State var deliveryType: String
    @State var address: String
    let photos: [UIImage]
    let viewSize: (CGSize) ->Void
    
    var body: some View {
        VStack(alignment:.leading, spacing: 20){
            
            Group{
                listItemRecapView(title: "Category", text: category)
                    .listRowSeparator(.hidden)
                listItemRecapView(title: "Title", text: title)
                    .listRowSeparator(.hidden)
                listItemRecapView(title: "Condition", text: condition)
                    .listRowSeparator(.hidden)
                listItemRecapView(title: "Description", text: description)
            }
            
            listDivider
    
            listItemRecapView(title: "Price", text: String(price))
            
            listDivider

            listItemRecapView(title: "Delivery type", text: deliveryType)
                .listRowSeparator(.hidden)

            listItemRecapView(title: "Address", text: address)
            
            listDivider
            
           photoList
            
        }
        .padding(.horizontal)
        .overlay(
            GeometryReader{ geo in
                Color.clear.onAppear{
                    withAnimation{
                        viewSize(geo.frame(in: .local).size)
                    }
                }
            }
        )
        
    }
    
    var listDivider: some View {
        HStack{
            Spacer()
            dividerCustom
                .frame(width: 100)
            Spacer()
        }
    }
    
    var photoList: some View {
        VStack(alignment:.leading, spacing: 5){
            Text("Photo")
                .font(.headline)
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(photos, id:\.self){ img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

    struct listItemRecapView: View {
        let title: String
        let text: String
        var body: some View{
            VStack(alignment:.leading, spacing: 5){
                Text(title)
                    .font(.headline)
                Text(text)
            }
        }
    }

struct RecapCreateAnnounce_Previews: PreviewProvider {
    static var previews: some View {
        RecapCreateAnnounce(createAnnounceVM: CreateAnnounceVM(), title: "Army of Two", description: "Best Coop Game", price: 12, category: "Game", condition: "Very Good", deliveryType: "Collection", address: "6 Allee, Francois, Villon", photos: [UIImage()], viewSize: {viewSize in })
    }
}
