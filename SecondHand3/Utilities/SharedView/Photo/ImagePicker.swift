//
//  ImagePicker.swift
//  SlideInMenuTest
//
//  Created by Benjamin Szakal on 14/10/22.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{

    let imagePicked :(UIImage) ->Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
   
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, imagePicked: imagePicked)
    }
    
    
    class Coordinator: PHPickerViewControllerDelegate {
        
        let parent: ImagePicker
        let imagePicked: (UIImage) -> Void
        
        init(parent: ImagePicker,  imagePicked: @escaping (UIImage)->Void) {
            self.parent = parent
            self.imagePicked = imagePicked
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard !results.isEmpty else { return }
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { res, err in
                        if err == nil {
                            if let uiImage = res as? UIImage {
                                
                                DispatchQueue.main.async {
                                    self.imagePicked(uiImage)
                                }
                                    
                                
                            }
                        }
                    })
                }
            }
            
        }
        
        
    }
    
    
}

