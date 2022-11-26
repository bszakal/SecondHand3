//
//  PhotoView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 23/11/22.
//
import NukeUI
import SwiftUI

struct photoView2: View {
    let imageUrlsString: [String]
    var imageToShowIfFail: SwiftUI.Image? = nil
    @State private var imageShowedIndex: Int = 0
    @State private var dragAmount = 0.0
    
    var body: some View{
        ZStack(alignment:.bottom){
            LazyImage(source: imageUrlsString[imageShowedIndex]) { state in
                if let image = state.image {
                    image
                } else if state.error != nil {
                    Color.gray
                    imageToShowIfFail?
                        .foregroundColor(.white)
                        .font(.largeTitle)
                } else {
                    ZStack{
                        Color.gray
                        imageToShowIfFail?
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
                
            }
            photoNbreIndicator(imageNbre: imageShowedIndex, totalNbre: imageUrlsString.count - 1)
                .foregroundColor(.white)
                .padding(.bottom)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .gesture(
        DragGesture()
            .onEnded({ value in
                if value.predictedEndLocation.x < value.startLocation.x {
                    if imageShowedIndex != imageUrlsString.count - 1 {
                        withAnimation{
                            imageShowedIndex += 1
                        }
                    }
                } else {
                    if imageShowedIndex != 0 {
                        withAnimation{
                            imageShowedIndex -= 1
                        }
                    }
                }
            })
        )
        
    }
        
}

struct photoNbreIndicator: View {
    
    let imageNbre: Int
    let totalNbre: Int
    
    var body: some View{
        HStack{
            if totalNbre == 0 {
                
            } else{
                ForEach(0...totalNbre, id:\.self) {nbre in
                    if nbre == imageNbre {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 10))
                    } else {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                    }
                }
            }
        }
    }
}

struct PhotoView2_Previews: PreviewProvider {
    static var previews: some View {
        let urls = ["https://firebasestorage.googleapis.com:443/v0/b/testlogin-zac.appspot.com/o/imagesAnnounces%2FB2FE052B-FE56-423A-960F-C8BF0769EFC9.jpeg?alt=media&token=599d48b2-b29e-4877-b41a-0401121a2c35", "https://firebasestorage.googleapis.com:443/v0/b/testlogin-zac.appspot.com/o/imagesAnnounces%2F177B2343-4BBC-4B97-A3A3-BE945EBF74FF.jpeg?alt=media&token=ad704c65-2db2-4de8-9bd2-73b7a6c868b1"]
        photoView2(imageUrlsString: urls)
    }
}
