//
//  ImageableView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 04.02.23.
//

import SwiftUI

struct ImageableView: View {
    @Binding var model: ImageableModel
    
    var body: some View {
        component
            .frame(height: 145)
            .frame(maxWidth: .infinity)
            .cornerRadius(16)
            .clipped()
            .contentShape(Rectangle())
        
            .onTapGesture {
                model.isConfirmationDialogPresented = true
            }
            .sheet(isPresented: $model.isImagePickerPresented) {
                ImagePickerView(selectedImage: $model.image)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $model.isPhotoPickerPresented) {
                PhotoPickerView(selectedImage: $model.image)
                    .ignoresSafeArea()
            }
            .confirmationDialog("?", isPresented: $model.isConfirmationDialogPresented) {
                Button("Camera") {
                    model.isImagePickerPresented = true
                }
                
                Button("Photo Gallery") {
                    model.isPhotoPickerPresented = true
                }
            }
    }
    
    private var component: some View {
        if let image = model.image {
            return Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipped()
                .clipShape(Rectangle())
                .toAnyView()
        } else {
            return ZStack {
                Color(hex: 0xD9D9D9)
                
                VStack(spacing: 8) {
                    DesignSystem.Image.placeholderPhoto()
                        .resizable()
                        .foregroundColor(Color(hex: 0x898484))
                        .frame(width: 32, height: 32)
                    
                    Text(model.placeholderText)
                        .foregroundColor(Color(hex: 0x898484))
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                }
                .padding(2)
                .offset(y: 8)
            }
            .toAnyView()
        }
    }
}


// MARK: - Model
struct ImageableModel {
    var image: UIImage? = nil
    var isImagePickerPresented = false
    var isPhotoPickerPresented = false
    var isConfirmationDialogPresented = false
    var placeholderText: String

    var isSelected: Bool {
        image.isNotNil
    }

    mutating func reset() {
        image = nil
        isImagePickerPresented = false
        isPhotoPickerPresented = false
        isConfirmationDialogPresented = false
    }
}

// MARK: - Previews
struct ImageableView_Previews: PreviewProvider {
    static var previews: some View {
        ImageableView(model: .constant(ImageableModel(placeholderText: "placeholderText")))
    }
}
