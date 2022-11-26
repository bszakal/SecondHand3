//
//  MyAnnouncesView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 13/11/22.
//

import SwiftUI

struct MyAnnouncesView: View {
    @StateObject var myAnnouncesVm = MyAnnouncesVM()
    
    var body: some View {
        

            List{
                ForEach(myAnnouncesVm.myAnnounces) {announce in
                    NavigationLink {
                        Text("To do..")
                    } label: {
                        myAnnounceSingleView(announce: announce)
                    }
                }
                .listRowSeparator(.hidden)
               
            }
            
            .listStyle(.plain)
            .onAppear{ myAnnouncesVm.getMyAnnounce() }

        .navigationTitle("My announces")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct myAnnounceSingleView: View {
    let announce: Announce
    
    var body: some View{
        HStack(alignment: .bottom){
            photoView2(imageUrlsString: announce.imageRefs)        
                .frame(width: 130, height: 150)
            TextView(announce: announce)
            Spacer()
        }
        .foregroundColor(.primary)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}




struct MyAnnouncesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MyAnnouncesView()
        }
    }
}
