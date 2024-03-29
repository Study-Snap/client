//
//  PhotoPicker.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-11-10.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    
    @Binding var classThumbnailImage: UIImage
    
    func makeUIViewController(context: Context) -> UIImagePickerController{
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker){
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage{
                guard let data = image.jpegData(compressionQuality: 0.1), let compressedImage = UIImage(data: data) else {
                          //show error or alert
                          return
                      }
                
                photoPicker.classThumbnailImage = compressedImage
                
            }else{
                //return error
            }
            picker.dismiss(animated: true)
        }
    }
}
