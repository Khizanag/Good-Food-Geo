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

    @State private var imageableModel0 = ImageableModel(placeholderText: imagePlaceholderTexts[0])
    @State private var imageableModel1 = ImageableModel(placeholderText: imagePlaceholderTexts[1])
    @State private var imageableModel2 = ImageableModel(placeholderText: imagePlaceholderTexts[2])
    @State private var imageableModel3 = ImageableModel(placeholderText: imagePlaceholderTexts[3])
    @State private var imageableModel4 = ImageableModel(placeholderText: imagePlaceholderTexts[4])

    private var imageableModels: [ImageableModel] {
        [imageableModel0, imageableModel1, imageableModel2, imageableModel3, imageableModel4]
    }

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

                // With ForEach image is not loaded from ImagePickerView on some devices
                Group {
                    ImageableView(model: $imageableModel0)
                    ImageableView(model: $imageableModel1)
                    ImageableView(model: $imageableModel2)
                    ImageableView(model: $imageableModel3)
                    ImageableView(model: $imageableModel4)
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
        .disabled(viewModel.isLoading)
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
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
                product: .init(title: productTitle, images: imageableModels.compactMap(\.image)),
                author: ProductComplaint.Author(fullName: fullName),
                comment: comment,
                location: location,
                termsAreAgreed: userAgreesTerms
            )
        )
    }

    private func cleanUp() {
        imageableModel0.reset()
        imageableModel1.reset()
        imageableModel2.reset()
        imageableModel3.reset()
        imageableModel4.reset()

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
