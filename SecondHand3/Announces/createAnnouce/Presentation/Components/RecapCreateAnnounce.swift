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
    
    var body: some View {
        VStack(alignment:.leading, spacing: 20){
            
            Group{
                VStack(alignment:.leading, spacing: 5){
                    Text("Category")
                        .font(.headline)
                    Text(category)
                }
                .listRowSeparator(.hidden)
                VStack(alignment:.leading, spacing: 5){
                    Text("Title")
                        .font(.headline)
                    Text(title)
                }
                .listRowSeparator(.hidden)
                VStack(alignment:.leading, spacing: 5){
                    Text("Condition")
                        .font(.headline)
                    Text(condition)
                    // .font(.subheadline)
                }
                .listRowSeparator(.hidden)
                VStack(alignment:.leading, spacing: 5){
                    Text("Description")
                        .font(.headline)
                    Text(description)
                }
            }
            HStack{
                Spacer()
                dividerCustom
                    .frame(width: 100)
                Spacer()
            }
            //.listRowSeparator(.hidden)
            VStack(alignment:.leading, spacing: 5){
                Text("Price")
                    .font(.headline)
                Text(price, format: .number)
            }
            HStack{
                Spacer()
                dividerCustom
                    .frame(width: 100)
                Spacer()
            }
            VStack(alignment:.leading, spacing: 5){
                Text("Delivery type")
                    .font(.headline)
                Text(deliveryType)
            }
            .listRowSeparator(.hidden)
            VStack(alignment:.leading, spacing: 5){
                Text("Address")
                    .font(.headline)
                Text(address)
            }
            HStack{
                Spacer()
                dividerCustom
                    .frame(width: 100)
                Spacer()
            }
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
            
//            Section{
//                Text(title)
//            } header: {
//                Text("Title")
//                    .font(.headline)
//            }
//            .listRowSeparator(.hidden)
        }
        //.listStyle(.plain)
        .padding(.horizontal)
       
    }
}

struct RecapCreateAnnounce_Previews: PreviewProvider {
    static var previews: some View {
        RecapCreateAnnounce(createAnnounceVM: CreateAnnounceVM(), title: "Army of Two", description: "Best Coop Game", price: 12, category: "Game", condition: "Very Good", deliveryType: "Collection", address: "6 Allee, Francois, Villon", photos: [UIImage()])
    }
}
