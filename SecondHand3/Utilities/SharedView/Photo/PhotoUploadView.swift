//
//  PhotoUploadView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 05/11/22.
//

import SwiftUI

struct photoPlacerHolderView: View {
    let image: Image?
    let photoNbre: Int
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.primary)
            VStack(spacing: 20){
                Image(systemName: "camera.viewfinder")
                    .scaleEffect(2.5)
                Text("Photo \(photoNbre)")
            }
            .foregroundColor(.primary).opacity(0.65)
            image?
                .resizable()
                .aspectRatio(contentMode: .fill)
               // .scaledToFill()
        }
        .shadow(radius: 1)
            
    }
}

struct photoPlacerHolderView_Previews: PreviewProvider {
    static var previews: some View {
        photoPlacerHolderView(image: nil, photoNbre: 1)
    }
}
