//
//  CreateAnnounceStartView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 05/11/22.
//
import Nuke
import NukeUI
import SwiftUI



struct CreateAnnounceStartView2: View {
    
    @State private var phaseNbre = 0
    
    @StateObject var createAnnounceVM = CreateAnnounceVM()
    @State private var selectedCategory = ""

    
    @State private var title: String = ""
    @State private var descrpition: String = "Description"
    @State private var price: Double?

    @State private var condition = ""
    
    @State private var addressLine = ""
    @State private var postCode = ""
    @State private var city = ""
    @State private var deliveryType = "Collection"
    
    @State private var imageHeight = 350
    @State private var viewOffset = CGSize.zero
    
    @State private var uiPhotosArray = [UIImage]()
    
    @Namespace private var namespace
    
    
    var fullAddress: String {
        if addressLine.isEmpty || postCode.isEmpty || city.isEmpty {
            return ""
        } else {
            return addressLine + ", " + postCode + ", " + city
        }
        
    }
    
    @State private var showUploadPhotoSheet = false
    
    var body: some View {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.black,.white]), startPoint: .bottomLeading, endPoint: .topTrailing)
                    .ignoresSafeArea()

   

                VStack(spacing:0){

                                Spacer()
                    VStack{
                        Group{
                            if phaseNbre == 1 {
                                selectionCategory
                                    //.transition(.move(edge: .bottom))
                                    .matchedGeometryEffect(id: "test", in: namespace)
                                    .animation(.linear(duration: 2), value:phaseNbre)
                                    .transition(.asymmetric(insertion: .move(edge: .bottom).animation(.linear(duration:1)), removal: .opacity))
                                    
                            } else if phaseNbre == 2 {
                                SelectionTitle2(title: $title, descrpition: $descrpition, price: $price)
                                    .matchedGeometryEffect(id: "test", in: namespace)
                                    .animation(.linear(duration: 2), value:phaseNbre)
                                    .transition(.asymmetric(insertion: .move(edge: .bottom).animation(.linear(duration:1)), removal: .opacity))
                            } else if phaseNbre == 3 {
                                
                            } else if phaseNbre == 4 {
                                
                            } else if phaseNbre == 6 {
                                Button("Create Announce") {
                                    Task{
                                        await createAnnounceVM.uploadAnnounce(title: title, description: descrpition, price: price!, category: selectedCategory, condition: condition, deliveryType: deliveryType, address: fullAddress, images: uiPhotosArray)
                                    }
                                }
                            }
                        }
                    }
         
                    bottomBar
                }
            }
        
        .toolbar(.hidden, for: .tabBar)
        
        .onChange(of: phaseNbre, perform: { newValue in
            if newValue == 5 {
                showUploadPhotoSheet = true
            }
        })
        .sheet(isPresented: $showUploadPhotoSheet,onDismiss: {
            if uiPhotosArray.isEmpty {
                withAnimation{
                    phaseNbre -= 1
                }
                showUploadPhotoSheet = false
            }
        }, content: {
            PhotoUploadSheet{ photos in
                uiPhotosArray = photos
                withAnimation{
                    phaseNbre += 1
                }
                    showUploadPhotoSheet = false
                
            }
        })
        .onAppear{
               createAnnounceVM.getCategories()
            }
        .onChange(of: createAnnounceVM.categories) { newValue in
            if !newValue.isEmpty {
                    phaseNbre = 1
            }
        }

    }
    
  @ViewBuilder  var selectionCategory: some View {
      VStack{
          HStack{
                      Text("Category")
              Spacer()
          }
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding()
          
          VStack{
              ForEach(createAnnounceVM.categories){ cat in
                  Text(cat.Name)
                  
                      .frame(maxWidth: .infinity, minHeight: 50)
                      .background(.white)
                      .clipShape(RoundedRectangle(cornerRadius: 10))
                      .modifier(selectionModifier(isSelected: selectedCategory == cat.Name))
                      .padding(.horizontal)
                      .contentShape(Rectangle())
                      .onTapGesture {
                          selectedCategory = cat.Name
                      }
              }
        
          }
          .padding()
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    var bottomBar: some View {
        VStack(spacing:0){
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight:2)
            HStack{
                if phaseNbre != 1 && phaseNbre != 0 {
                    Button("Back") {
                        withAnimation(.linear(duration: 0.5)) {
                            phaseNbre -= 1
                        }
                        
                    }
                    .modifier(buttonModifierCreateAnnouce())
                    .disabled(phaseNbre == 1)
                }
                Spacer()
                Button("Next") {
                    withAnimation(.linear(duration: 0.5)) {
                        phaseNbre += 1
                    }
                    print(phaseNbre)
                }
                .modifier(buttonModifierCreateAnnouce())
                .disabled(phaseNbre == 1 && selectedCategory == "")
                .disabled(phaseNbre == 2 && (title == "" || price == nil))
                .disabled(phaseNbre == 3 && condition == "")
                .disabled(phaseNbre == 4 && (fullAddress == "" || deliveryType == ""))

            }
        }
        .background(.white)
    }
}

struct SelectionTitle2: View {
    
    @Binding var title: String
    @Binding var descrpition: String
    @Binding var price: Double?
    
    var body: some View{
        VStack(spacing:10){
            Group{
                TextField(text: $title, label: {
                    Text("Title")
                })
                .padding()
                .frame(maxWidth: .infinity, minHeight: 50)
               
                TextField(value: $price, format: .number, label: {
                    Text("Price")
                })
                .padding()
                .frame(maxWidth: .infinity, minHeight: 50)
            
                TextEditor(text: $descrpition)
                    .multilineTextAlignment(.leading)
                    .frame(height: 150)
                    .foregroundColor(.primary)
                    .padding()
                    
                
            }
            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundColor(.primary).opacity(0.1))
            .padding(.horizontal)
            
        }
        .padding(.vertical)
        .background(.white)

                .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}



struct CreateAnnounceStartView2_Previews: PreviewProvider {
    static var previews: some View {
        CreateAnnounceStartView2()
    }
}

