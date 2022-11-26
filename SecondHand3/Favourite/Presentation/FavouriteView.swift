//
//  FavouriteView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 07/11/22.
//

import SwiftUI

struct FavouriteView: View {

    @StateObject var favouriteVM = FavouriteVM()
    @State private var useTempData = true
    
    var body: some View {
        
            NavigationStack{
                ScrollView{
                    
                    if useTempData {
                        tempDataViewFavourite
                    } else {
                        ForEach(favouriteVM.favouriteAnnounces){ announce in
                            NavigationLink {
                                AnnounceDetailedView(announce: announce)
                            } label: {
                                announceView(announce: announce, favouriteVM: favouriteVM)
                            }
                        }
                        .padding(.vertical, 10)
                        
                    }
                    
                }
                .padding([.horizontal])
                .navigationTitle("Favourites")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.gray, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                
            }
            
            .onChange(of: favouriteVM.finishedLoading, perform: { newValue in
                if newValue {
                    withAnimation{
                        useTempData = false
                    }
                }
            })
            
            .onAppear{
                favouriteVM.getFavourites()
            }
        
    }
    
    var tempDataViewFavourite: some View {
        HStack{
            Spacer()
            ProgressView()
                .font(.largeTitle)
                .scaleEffect(2)
            Spacer()
        }
        .padding(.top, 50)
    }
}
struct announceView: View {
    let announce: Announce
    @ObservedObject var favouriteVM: FavouriteVM
    
    var body: some View{
        HStack{
            ZStack(alignment:.topTrailing){
                photoView2(imageUrlsString: announce.imageRefs)
                
                FavouriteHeartView(isAFavourite: true) {
                    favouriteVM.AddOrRemoveFromFavourite(announce: announce)
                }
                .padding(5)
                
            }
                .frame(width: 100, height: 140)
            TextView(announce: announce)
            Spacer()
        }
        .foregroundColor(.primary)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

struct TextView: View {
    let announce: Announce
    
    var body: some View{
        VStack(alignment:.leading, spacing: 5){
            VStack(alignment:.leading){
                Text(announce.title)
                    .font(.headline)
                
                HStack(spacing:2){
                    Text(announce.price, format: .number)
                    Text(Locale.current.currencySymbol ?? "EUR")
                }
                .font(.headline)
            }
            
            Text(announce.category)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                
            VStack(alignment:.leading){
                Text(announce.city_PostCode)
                Text(announce.lastUpdatedAt ?? Date(), format: .dateTime)
            }
            .font(.subheadline)
           
            Text(announce.deliveryType)
                .font(.subheadline)
                .underline()
                
        }

    }
}





struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
