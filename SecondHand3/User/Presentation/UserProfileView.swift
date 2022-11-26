//
//  UserProfileView.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 12/11/22.
//
import NukeUI
import SwiftUI

struct UserProfileView: View {
    
    @StateObject var userProfileVM = UserProfileVM()
    @Environment(\.dismiss) var dismiss
    
    @State private var addressEditingDisabled = true
    @State private var showPhotoLibrary = false
    @State private var showCamera = false
    @State private var showPictureConfirmationDialogue = false
    @State private var newPhotoUI: UIImage?
    private var newPhoto: SwiftUI.Image? {
        if let uiImg = newPhotoUI {
            return Image(uiImage: uiImg)
        } else {
            return nil
        }
    }
    
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading, spacing:30){
                VStack{
                    profilePictureView
                    names
                }
                dividerCustom
                email
                dividerCustom
                address
            }
            .padding(.horizontal)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {saveButton})
        
        .onAppear{ userProfileVM.getUserProfileOrPrepareNewOne() }
        
        .sheet(isPresented: $showPhotoLibrary, content: {
            ImagePicker {img in self.newPhotoUI = img}
        })
        .sheet(isPresented: $showCamera, content: {
            Camera {img in self.newPhotoUI = img}
        })
        
        .confirmationDialog("Upload photo", isPresented: $showPictureConfirmationDialogue, actions: {
            Button("Photo Library") { self.showPhotoLibrary = true }
            Button("Camera") { self.showCamera = true }

        })
        
    }
    
    var profilePictureView: some View {
        ZStack(alignment:.bottomTrailing){
            imageView
                .clipShape(Circle())
            Button {
                showPictureConfirmationDialogue = true
            } label: {
                Image(systemName: "camera.fill")
                    .foregroundColor(.primary)
            }

        }
        .frame(width: 200, height: 200)
        .padding(.bottom,30)
    }
    
    var saveButton: some View {
        Button {
            userProfileVM.saveProfile(img: newPhotoUI)
            dismiss()
        } label: {
            Text("Save")
                .fontWeight(.semibold)
                .underline()
                .foregroundColor(.primary)
                .padding()
                
        }
    }
    
    var imageView: some View {
        ZStack{
            LazyImage(source: userProfileVM.userProfile?.profilePictureUrlStr ?? "") { state in
                if let image = state.image {
                    image
                } else if state.error != nil {
                    Color.gray
                } else {
                    ZStack{
                        Color.gray
                        Image(systemName: "photo.artframe")
                            .foregroundColor(.white)
                    }
                }
            }
            newPhoto?
                .resizable()
        }
    }
    
    var names: some View {
        Group{
            textfieldNamesView(title: "Pseudo", text: $userProfileVM.pseudo)
            textfieldNamesView(title: "First name", text: $userProfileVM.firstName)
            textfieldNamesView(title: "Last name", text: $userProfileVM.lastName)
        }
    }
    
    var email: some View {
        VStack(alignment:.leading, spacing: 4){
            Text("Email")
            Text(userProfileVM.emailAddress)
                .foregroundColor(.secondary)
        }
    }
    
    var address: some View {
  
        VStack(alignment:.leading, spacing: 4){
            HStack{
                Text("Address")
                Spacer()
                Button {
                    addressEditingDisabled.toggle()
                } label: {
                    Text(addressEditingDisabled ? "Edit" : "Done")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .underline()
                }

            }
            
            TextField("Address", text: $userProfileVM.address)
                .foregroundColor(.secondary)
                .disabled(addressEditingDisabled)
        }
    }
}

struct textfieldNamesView: View {
    let title: String
    @Binding var text: String
    var body: some View{
        VStack(alignment:.leading, spacing: 0){
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField(title, text: $text)
                .autocorrectionDisabled()
        }
        .padding(7)
        .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.secondary))
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            UserProfileView()
        }
    }
}
