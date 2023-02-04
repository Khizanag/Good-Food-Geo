//
//  ImagePickerView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import UIKit
import SwiftUI

// MARK: - ImagePickerView
struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
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
extension ImagePickerView {
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let picker: ImagePickerView

        init(picker: ImagePickerView) {
            self.picker = picker
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            self.picker.selectedImage = info[.originalImage] as? UIImage
            self.picker.shouldDismiss()
        }
    }
}
