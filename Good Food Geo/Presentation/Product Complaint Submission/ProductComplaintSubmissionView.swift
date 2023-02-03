//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ProductComplaintSubmissionView: View {
    // MARK: - Typealias
    typealias ViewModel = ProductComplaintSubmissionViewModel

    // MARK: - Properties
    private enum Field: Arrangeable {
        case productTitle
        case fullName
        case comment
        case location

        var arranged: [Field] {
            [.productTitle, .fullName, .comment, .location]
        }
    }

    @ObservedObject var viewModel: ViewModel

    private static let imagePlaceholderTexts = [
        Localization.scanFirstImageDescription(),
        Localization.scanSecondImageDescription(),
        Localization.scanThirdImageDescription(),
        Localization.scanFourthImageDescription(),
        Localization.scanFifthImageDescription()
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
    @State private var comment = ""
    @State private var location = ""

    @State private var userAgreesTerms = false

    @FocusState private var focusedField: Field?

    @State private var alertData = AlertData()

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                Text(Localization.preScanFormTitle().uppercased())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()

                FormItemView(model: FormItemModel(icon: DesignSystem.Image.photo(), placeholder: Localization.productTitle()), text: $productTitle)
                    .focused($focusedField, equals: .productTitle)

                ForEach(selectableImages.indices, id: \.self) { index in
                    selectedImageComponent(for: index)
                }

                VStack {
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.person(), placeholder: Localization.fullName()), text: $fullName)
                        .focused($focusedField, equals: .fullName)
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.pencil(), placeholder: Localization.comment()), text: $comment)
                        .focused($focusedField, equals: .comment)
                    FormItemView(model: FormItemModel(icon: DesignSystem.Image.location(), placeholder: Localization.location()), text: $location)
                        .focused($focusedField, equals: .location)
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
            .padding(.horizontal, 32)
            .onSubmit {
                guard let focusedField = focusedField else { return }
                guard let nextField = focusedField.next else {
                    submit()
                    return
                }
                self.focusedField = nextField
            }

            VSpacing(MainTabBarConstant.height - 16)
        }
        .scrollDismissesKeyboard(.interactively)
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
            .frame(maxWidth: .infinity)
            .cornerRadius(16)
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                selectableImages[index].isConfirmationDialogPresented = true
            }
            .sheet(isPresented: $selectableImages[index].isImagePickerPresented) {
                ImagePickerView(selectedImage: $selectableImages[index].image)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $selectableImages[index].isPhotoPickerPresented) {
                PhotoPickerView(selectedImage: $selectableImages[index].image)
                    .ignoresSafeArea()
            }
            .confirmationDialog("?", isPresented: $selectableImages[index].isConfirmationDialogPresented) {
                Button("Camera") {
                    selectableImages[index].isImagePickerPresented = true
                }

                Button("Photo Gallery") {
                    selectableImages[index].isPhotoPickerPresented = true
                }
            }
    }

    private func getImageOrPlaceholder(for index: Int) -> some View {
        if let image = selectableImages[index].image {
            return Image(uiImage: image)
                .resizable()
                .scaledToFill()
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
        .cornerRadius(16)
    }

    private var submitButton: some View {
        PrimaryButton(
            action: submit,
            label: {
                Label(title: {
                    Text(Localization.send())
                        .padding()
                }, icon: {
                    DesignSystem.Image.submit()
                        .imageScale(.large)
                })
            },
            isLoading: $viewModel.isLoading,
            backgroundColor: Color(hex: 0x4285F4)
        )
    }

    // MARK: - Functions
    private func submit() {
        viewModel.submitProductComplaint(
            ProductComplaint(
                product: .init(title: productTitle, images: selectableImages.compactMap(\.image)),
                author: ProductComplaint.Author(fullName: fullName),
                comment: comment,
                location: location,
                termsAreAgreed: userAgreesTerms
            )
        )
    }

    private func cleanUp() {
        selectableImages.indices.forEach { index in
            selectableImages[index].reset()
        }

        productTitle = ""
        fullName = ""
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
