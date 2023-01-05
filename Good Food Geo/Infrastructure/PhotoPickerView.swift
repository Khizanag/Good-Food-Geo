//
//  PhotoPicker.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 05.01.23.
//

import UIKit
import SwiftUI
import PhotosUI
import Photos

struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    @Environment(\.dismiss) private var dismiss: DismissAction

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {

        private let parent: PhotoPickerView

        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImage = nil

            guard results.count <= 1 else { return }
            guard let image = results.first else { return }

            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                    if let error = error {
                        print("Can't load image \(error.localizedDescription)")
                    } else if let image = newImage as? UIImage {
                        // Add new image and pass it back to the main view
                        self?.parent.selectedImage = image
                    }
                }
            } else {
                print("Can't load asset")
            }

            // close the modal view
            parent.dismiss()
        }
    }
}
