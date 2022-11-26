//
//  PhotoUploadSheet.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 05/11/22.
//

import SwiftUI

struct PhotoUploadSheet: View {
    
    @Environment(\.dismiss) var dismiss
   
    @State private var showConfirmation = false
    @State private var showPhotoLibrary = false
    @State private var showCamera = false
    @State private var uiPhotosDico = [Int: UIImage]()
    @State private var selectedPhoto = 0
    @State private var uiPhotosArray = [UIImage]()
    let CompletionHandler: ([UIImage]) -> Void
    
    var body: some View {
        VStack{
            title
                .padding(.top)
            
            VStack{
                
                ScrollView{
                    photoPlacerHolderView(image: convertOptionalUiImgToOptionalImg(nbre: 1), photoNbre: 1)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showConfirmation = true
                            selectedPhoto = 1
                        }
                        .padding(.horizontal)
                    LazyVGrid(columns: [GridItem(), GridItem()]){
                        ForEach(2...6, id:\.self){ nbre in
                            photoPlacerHolderView(image: convertOptionalUiImgToOptionalImg(nbre: nbre), photoNbre: nbre)
                                .frame(width: 175, height: 175)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    showConfirmation = true
                                    selectedPhoto = nbre
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing:0){
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight:1)
                    HStack{
                        Button("Back") {
                            dismiss()
                            
                        }
                        .modifier(buttonModifierCreateAnnouce())
                        Spacer()
                        Button("Next") {
                            uiPhotosArray = uiPhotosDico.map{$0.value}
                            CompletionHandler(uiPhotosArray)
                            
                        }
                        .modifier(buttonModifierCreateAnnouce())
                        .disabled(uiPhotosDico.isEmpty)
                    }
                }
            }
            
        }
        .confirmationDialog("Upload Photo", isPresented: $showConfirmation, actions: {
            Button("Library") {showPhotoLibrary = true}
            Button("Camera") {showCamera = true}
        })
        .sheet(isPresented: $showPhotoLibrary, content: {
            ImagePicker {img in
                self.uiPhotosDico[selectedPhoto] = img
            }
        })
        .sheet(isPresented: $showCamera, content: {
            Camera {img in
                if let photo = img {
                    self.uiPhotosDico[selectedPhoto] = photo
                }
                showCamera = false
            }
        })
        
    }
    
    var title: some View {
        VStack{
            ZStack{
                Text("Upload Photos")
                    .fontWeight(.bold)
                HStack{
                    Image(systemName: "xmark")
                        .padding(.leading)
                        .font(.title3)
                        .onTapGesture {
                            dismiss()
                        }
                        
                    Spacer()

                }
            }
            .font(.title2)
            //.padding(.top, 20)
            dividerCustom
            
        }
    }
    
    func convertOptionalUiImgToOptionalImg(nbre: Int) -> Image? {
        if let uiPhoto = uiPhotosDico[nbre] {
            return Image(uiImage: uiPhoto)
        } else {
            return nil
        }
    }
}


struct PhotoUploadSheet_Previews: PreviewProvider {
    static var previews: some View {
        PhotoUploadSheet(CompletionHandler: {_ in })
    }
}
