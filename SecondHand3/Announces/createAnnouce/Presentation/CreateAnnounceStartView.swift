//
//  CreateAnnounceStartView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 05/11/22.
//
import Nuke
import NukeUI
import SwiftUI



struct CreateAnnounceStartView: View {
    
    @State private var phaseNbre = 0
    
    @StateObject var createAnnounceVM = CreateAnnounceVM()
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategory = ""

    @State private var title: String = ""
    @State private var descrpition: String = "Description"
    @State private var price: Double?

    @State private var condition = ""
    
    @State private var addressLine = ""
    @State private var postCode = ""
    @State private var city = ""
    @State private var deliveryType = "Collection"
    
    @State private var viewOffset = CGSize.zero
    
    @State private var uiPhotosArray = [UIImage]()
    
    @State private var showConfirmationDialogue = false
    
    
    var fullAddress: String {
        if addressLine.isEmpty || postCode.isEmpty || city.isEmpty {
            return ""
        } else {
            return addressLine + ", " + postCode + ", " + city
        }
        
    }
    
    @State private var showUploadPhotoSheet = false
    
    var body: some View {
        GeometryReader{ geox in
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.black,.white]), startPoint: .bottomLeading, endPoint: .topTrailing)
                    .ignoresSafeArea()
                HStack{
                        if phaseNbre == 1 {
                            Text("Category")
                            
                        } else if phaseNbre == 3 {
                            Text("Title & Price")
                            
                        } else if phaseNbre == 2 {
                            Text("Condition")
                        } else if phaseNbre == 4 {
                            Text("Deliver & Address")
                        } else if phaseNbre == 6 {
                            Text("Recap")
                        }
                    Spacer()
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
                .offset(y: Double.maximum(geox.frame(in: .local).height/2 - viewOffset.height - 200.0, -geox.frame(in: .local).height/2 + 20))

                VStack{

                    ScrollView{
                        
                            VStack(spacing:30) {
                                Spacer()
                                
                                if phaseNbre == 1 {
                                        selectionCategory(createAnnounceVM: createAnnounceVM, selectedCategory: $selectedCategory)
                                            .overlay(
                                                GeometryReader{ geo in
                                                    Color.clear.onAppear{
                                                        withAnimation{
                                                            self.viewOffset = geo.frame(in: .local).size
                                                        }
                                                    }
                                                }
                                            )
                                    
                                } else if phaseNbre == 3 {
                                    SelectionTitle(title: $title, descrpition: $descrpition, price: $price)
                                        .overlay(
                                            GeometryReader{ geo in
                                                Color.clear.onAppear{
                                                    withAnimation{
                                                        self.viewOffset = geo.frame(in: .local).size
                                                    }
                                                }
                                            }
                                        )
                                } else if phaseNbre == 2 {
                                    SelectionCondition(condition: $condition)
                                        .overlay(
                                            GeometryReader{ geo in
                                                Color.clear.onAppear{
                                                    withAnimation{
                                                        self.viewOffset = geo.frame(in: .local).size
                                                    }
                                                }
                                            }
                                        )
                                } else if phaseNbre == 4 {
                                    SelectionAddress(addressLine: $addressLine, postCode: $postCode, city: $city, deliveryType: $deliveryType)
                                        .overlay(
                                            GeometryReader{ geo in
                                                Color.clear.onAppear{
                                                    withAnimation{
                                                        self.viewOffset = geo.frame(in: .local).size
                                                    }
                                                }
                                            }
                                        )
                                } else if phaseNbre == 6 {
                                        RecapCreateAnnounce(createAnnounceVM: createAnnounceVM, title: title, description: descrpition, price: price!, category: selectedCategory, condition: condition, deliveryType: deliveryType, address: addressLine, photos: uiPhotosArray)
                                        .transition(.move(edge: .bottom)).animation(.linear(duration: 1), value: phaseNbre)
                                        .overlay(
                                            GeometryReader{ geo in
                                                Color.clear.onAppear{
                                                    withAnimation{
                                                        self.viewOffset = geo.frame(in: .local).size
                                                    }
                                                }
                                            }
                                        )
                                }
                                
                                Spacer()
                            }
                            
                        
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .offset(y: Double.maximum(geox.frame(in: .local).height - viewOffset.height - 120.0, 50.0))
                    
                    bottomBar
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            Button {
                showConfirmationDialogue = true
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(Circle().foregroundColor(.black))
            }

        }
        
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
        .confirmationDialog("Are you sure?", isPresented: $showConfirmationDialogue) {
            Button("Confirm", role: .destructive){
                dismiss()
            }
            Button("Cancel", role: .cancel) {
                showConfirmationDialogue = false
            }
        } message: {
            Text("Are you sure you want to exit?")
                .font(.title)
        }
        
    }

    
    var bottomBar: some View {
        VStack(spacing:0){
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight:2)
            HStack{
                if phaseNbre != 1 && phaseNbre != 0 {
                    Button("Back") {
                        withAnimation {
                            phaseNbre -= 1
                        }
                        
                    }
                    .modifier(buttonModifierCreateAnnouce())
                    .disabled(phaseNbre == 1)
                }
                Spacer()
                
                Button(action: {
                    if phaseNbre == 6 {
                        createAnnounceVM.uploadAnnounce(title: title, description: descrpition, price: price!, category: selectedCategory, condition: condition, deliveryType: deliveryType, address: fullAddress, images: uiPhotosArray)
                        
                        dismiss()
                    }
                    
                    withAnimation {
                        phaseNbre += 1
                    }
                }, label: {
                    Text(phaseNbre == 6 ? "Create!" : "Next")
                })
                .modifier(buttonModifierCreateAnnouce())
                .disabled(phaseNbre == 1 && selectedCategory == "")
                .disabled(phaseNbre == 3 && (title == "" || price == nil))
                .disabled(phaseNbre == 2 && condition == "")
                .disabled(phaseNbre == 4 && (fullAddress == "" || deliveryType == ""))
                
            }
        }
        .background(.white)
    }
}





struct selectionModifier: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        if isSelected {
            content
                .background(
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3).foregroundColor(.primary).opacity(1)
            )
        } else {
            content
                .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3).foregroundColor(.primary).opacity(0.1))
        }
    }
}



struct buttonModifierCreateAnnouce: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding(.vertical)
            .padding(.horizontal, 30)
            .background(.black.opacity(0.7))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 30)
            .padding(.top, 15)
    }
}

struct CreateAnnounceStartView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAnnounceStartView()
    }
}
