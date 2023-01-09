//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ProductComplaintSubmissionView: View {
    private struct SelectableImageInfo {
        var image: UIImage? = nil
        var isImagePickerPresented: Bool = false
        var isPhotoPickerPresented: Bool = false
        var isConfirmationDialogPresented: Bool = false

        var isSelected: Bool {
            image.isNotNil
        }
    }

    @State private var selectableImages: [SelectableImageInfo] = [.init(), .init(), .init()]

    @State private var productTitle = ""
    @State private var fullName = ""
    @State private var idNumber = ""
    @State private var comment = ""
    @State private var location = ""

    @State private var userAgreesTerms = false

    @State private var alertData = AlertData()

    var body: some View {
        ScrollView {
            VStack {
                Text(Localization.preScanFormTitle().uppercased())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()

                FormItemView(model: FormItemModel(icon: DesignSystem.Image.photo(), placeholder: "Product Title..."), text: $productTitle)


                HStack {
                    ForEach(selectableImages.indices, id: \.self) { index in
                        selectedImageComponent(for: index)
                    }
                }

                VStack {
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.person(), placeholder: Localization.fullName()), text: $fullName)
                        .onSubmit {
                            print("should activate next field")
                        }
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.fingerprint(), placeholder: Localization.idNumber(), keyboardType: .numberPad), text: $idNumber)
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.pencil(), placeholder: Localization.comment()), text: $comment)
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.location(), placeholder: Localization.location()), text: $location)
                }

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
            }
            .padding([.horizontal], 32)

            VSpacing(MainTabBarConstant.height)
        }
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
    }

    // MARK: - Components
    private func selectedImageComponent(for index: Int) -> some View {
        getImageOrPlaceholder(for: index)
            .frame(height: 145)
            .clipped()
            .cornerRadius(15)
            .onTapGesture {
                selectableImages[index].isConfirmationDialogPresented = true
            }
            .sheet(isPresented: $selectableImages[index].isImagePickerPresented) {
                ImagePickerView(selectedImage: $selectableImages[index].image, sourceType: .camera)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $selectableImages[index].isPhotoPickerPresented) {
                PhotoPickerView(selectedImage: $selectableImages[index].image)
                    .ignoresSafeArea()
            }
            .confirmationDialog("How to select photo?", isPresented: $selectableImages[index].isConfirmationDialogPresented) {
                Button("Camera") {
                    selectableImages[index].isImagePickerPresented = true
                }

                Button("Photo Library") {
                    selectableImages[index].isPhotoPickerPresented = true
                }
            }

    }

    private func getImageOrPlaceholder(for index: Int) -> some View {
        if let image = selectableImages[index].image {
            return Image(uiImage: image)
                .resizable()
                .toAnyView()
        } else {
            return imagePlaceholder
                .toAnyView()
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
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .offset(y: 8)
        }
        .cornerRadius(15)
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

            guard selectableImages.allSatisfy(\.isSelected) else {
                showMessage("Please select image all images to submit the information")
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
        [productTitle, fullName, idNumber, comment, location].allSatisfy { !$0.isEmpty }
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
        ProductComplaintSubmissionView()
    }
}
