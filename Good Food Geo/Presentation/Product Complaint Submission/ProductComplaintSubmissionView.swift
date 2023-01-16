//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ProductComplaintSubmissionView: View {
    typealias ViewModel = ProductComplaintSubmissionViewModel

    @ObservedObject var viewModel: ViewModel

    private static let imagePlaceholderTexts = [
        "გადაუღე ნათლად პროდუქტის ვადას",
        "გადაუღე ნათლად პროდუქტის წინა მხარეს",
        "გადაუღე ნათლად პროდუქტის უკანა მხარეს",
        "პროდუქტის მარცხენა ან ზედა მხარე",
        "პროდუქტის ნათლად მარჯვენა ან ქვედა მხარე"
    ]

    private struct SelectableImageInfo {
        var image: UIImage? = nil
        var isImagePickerPresented = false
        var isPhotoPickerPresented = false
        var isConfirmationDialogPresented = false
        let placeholderText: String

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

    @State private var selectableImages = imagePlaceholderTexts.map { SelectableImageInfo(placeholderText: $0) }

    @State private var productTitle = ""
    @State private var fullName = ""
    @State private var idNumber = ""
    @State private var comment = ""
    @State private var location = ""

    @State private var userAgreesTerms = false

    @State private var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                Text(Localization.preScanFormTitle().uppercased())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()

                FormItemView(model: FormItemModel(icon: DesignSystem.Image.photo(), placeholder: "Product Title..."), text: $productTitle)

                selectedImageComponent(for: 0)

                HStack {
                    selectedImageComponent(for: 1)
                    selectedImageComponent(for: 2)
                }

                HStack {
                    selectedImageComponent(for: 3)
                    selectedImageComponent(for: 4)
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

            VSpacing(MainTabBarConstant.height - 16)
        }
        .onReceive(viewModel.errorPublisher, perform: showError)
        .onReceive(viewModel.eventPublisher) { event in
            switch event {
            case .cleanUp:
                cleanUp()
            }
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
            return getImagePlaceholder(for: index)
                .toAnyView()
        }
    }

    private func getImagePlaceholder(for index: Int) -> some View {
        ZStack {
            Color(hex: 0xD9D9D9)

            VStack(spacing: 8) {
                DesignSystem.Image.placeholderPhoto()
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(hex: 0x898484))
                    .frame(width: 32, height: 32)

                Text(selectableImages[index].placeholderText)
                    .foregroundColor(Color(hex: 0x898484))
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            }
            .padding(2)
            .offset(y: 8)
        }
        .cornerRadius(15)
    }


    private var submitButton: some View {
        Button(
            action: {
                viewModel.submitProductComplaint(
                    ProductComplaint(
                        product: .init(title: productTitle, images: selectableImages.compactMap(\.image)),
                        author: ProductComplaint.Author(fullName: fullName, idNumber: idNumber),
                        comment: comment,
                        location: location,
                        areTermsAgreed: userAgreesTerms
                    )
                )
            },
            label: {
                if !viewModel.isLoading {
                    Label(title: {
                        Text("გაგზავნა")
                    }, icon: {
                        DesignSystem.Image.submit()
                            .imageScale(.large)
                    })
                } else {
                    ProgressView()
                }
            }
        )
        .disabled(viewModel.isLoading)
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(DesignSystem.Color.buttonTitle())
        .background(Color(hex: 0x4285F4))
        .cornerRadius(15)
    }

    // MARK: - Functions
    private func cleanUp() {
        selectableImages.indices.forEach { index in
            selectableImages[index].reset()
        }

        productTitle = ""
        fullName = ""
        idNumber = ""
        comment = ""
        location = ""

        userAgreesTerms = false
    }

    // MARK: - Message Displayer
    private func showError(_ error: AppError) {
        showMessage(error.description)
    }

    private func showMessage(_ message: String, description: String? = nil) {
        alertData.title = message
        if let description {
            alertData.subtitle = description
        }
        alertData.isPresented = true
    }
}

// MARK: - Previews
struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ProductComplaintSubmissionView(viewModel: ProductComplaintSubmissionViewModel())
    }
}
