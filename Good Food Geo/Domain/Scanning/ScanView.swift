//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ScanView: View {
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
            Text(Localization.preScanFormTitle().uppercased())
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()

            selectedImageContainer
                .frame(height: 145)
                .frame(maxWidth: .infinity)
                .cornerRadius(15)
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePickerView(selectedImage: $selectedImage, sourceType: sourceType)
                        .ignoresSafeArea()
                }
                .sheet(isPresented: $isPhotoPickerPresented) {
                    PhotoPickerView(selectedImage: $selectedImage)
                        .ignoresSafeArea()
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

            submitButton

            Spacer()
        }
        .padding(32)
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }

    // MARK: - Components
    private var selectedImageContainer: some View {
        if selectedImage == nil {
            return AnyView(imagePlaceholder)
        } else {
            return AnyView(selectedImageView)
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            Color(hex: 0xD9D9D9)

            VStack(spacing: 8) {
                    DesignSystem.Image.placeholderPhoto()
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(hex: 0x898484))
                        .frame(width: 32, height: 32)

                    Text("Touch to choose the image")
                        .foregroundColor(Color(hex: 0x898484))
            }
            .offset(y: 8)
        }
    }

    private var selectedImageView: some View {
        Image(uiImage: selectedImage!)
            .resizable()
            .scaledToFill()
    }

    private var submitButton: some View {
        Button(action: {
            guard allFieldsAreFilled else {
                showMessage("All fields should be filled to submit the information")
                return
            }

            guard userAgreesTerms else {
                showMessage("You should accept our terns of Use and Privacy Statement to submit the information")
                return
            }

            guard selectedImage != nil else {
                showMessage("Please select image to submit the information")
                return
            }

            // TODO: SUBMIT your information
        }, label: {

            DesignSystem.Image.submit()
                .imageScale(.large)

            Text("Submit your information")
        })
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(DesignSystem.Color.buttonTitle())
        .background(Color(hex: 0x4285F4))
        .cornerRadius(15)
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

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
