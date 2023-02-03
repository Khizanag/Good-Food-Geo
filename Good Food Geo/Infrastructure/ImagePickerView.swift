//
//  ImagePickerView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import UIKit
import SwiftUI

#warning("Refactor ImagePicker and PhotoPicker, choose one?")
// MARK: - ImagePickerView
struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedImage: UIImage?
    
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }
    
    func shouldDismiss() {
        dismiss()
    }
}

// MARK: - Coordinator
final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.shouldDismiss()
    }
}
