//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct PreScanFormView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isPhotoPickerPresented = false
    @State private var isConfirmationDialogPresented = false

    @State private var fullName = ""
    @State private var idNumber = ""
    @State private var comment = ""
    @State private var location = ""

    private var textFields: [String] {
        [fullName, idNumber, comment, location]
    }

    @State private var userAgreesTerms = false

    @State private var alertData = AlertData()

    var body: some View {
        VStack {
            (selectedImage != nil ? Image(uiImage: selectedImage!) : Image(systemName: "snow"))
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 300, height: 300)
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePickerView(selectedImage: $selectedImage, sourceType: sourceType)
                }
                .sheet(isPresented: $isPhotoPickerPresented) {
                    PhotoPicker(selectedImage: $selectedImage)
                }
                .confirmationDialog("How to open photo?", isPresented: $isConfirmationDialogPresented) {
                    Button("Camera") {
                        isImagePickerPresented = true
                    }

                    Button("Photo Library") {
                        isPhotoPickerPresented = true
                    }
                }
                .onTapGesture {
                    isConfirmationDialogPresented = true
                }

            Spacer()
            
            Text(Localization.preScanFormTitle().uppercased())
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()

            FormItemView(model: FormItemModel(icon: DesignSystem.Image.person(), placeholder: Localization.fullName()), text: $fullName)
            FormItemView(model: FormItemModel(icon: DesignSystem.Image.fingerprint(), placeholder: Localization.idNumber(), keyboardType: .numberPad), text: $idNumber)
            FormItemView(model: FormItemModel(icon: DesignSystem.Image.pencil(), placeholder: Localization.comment()), text: $comment)
            FormItemView(model: FormItemModel(icon: DesignSystem.Image.location(), placeholder: Localization.location()), text: $location)

            Toggle(isOn: $userAgreesTerms) {
                Text(Localization.acceptTerms())
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(DesignSystem.Color.secondaryText())
                    .multilineTextAlignment(.trailing)
            }
            .tint(DesignSystem.Color.primary())
            .padding()

            Button(action: {
                guard allFieldsAreFilled else {
                    showMessage("All fields should be empty to navigate to scanning")
                    return
                }

                guard userAgreesTerms else {
                    showMessage("You should accept our terns of Use and Privacy Statement to navigate to scanning")
                    return
                }

                // TODO: Navigate to the Camera
            }, label: {
                DesignSystem.Image.qr()
                    .imageScale(.large)

                Text(Localization.scanProduct())
            })
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(DesignSystem.Color.buttonTitle())
            .background(DesignSystem.Color.buttonImportant())
            .cornerRadius(15)

            Spacer()
        }
        .padding(32)
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }

    private var allFieldsAreFilled: Bool {
        textFields.allSatisfy { !$0.isEmpty }
    }

    // MARK: - Show Message
    private func showMessage(_ message: String, description: String? = nil) {
        alertData.title = message
        if let description {
            alertData.subtitle = description
        }
        alertData.isPresented = true
    }
}

struct PreScanFormView_Previews: PreviewProvider {
    static var previews: some View {
        PreScanFormView()
    }
}
