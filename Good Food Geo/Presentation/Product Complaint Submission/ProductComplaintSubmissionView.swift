//
//  PreScanFormView.swift
//  Good Food Geo
//
//  Created by Giga Khizanishvili on 23.12.22.
//

import SwiftUI

struct ProductComplaintSubmissionView: View {
    // MARK: - Properties
    @StateObject var viewModel: ProductComplaintSubmissionViewModel

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
                VStack(alignment: .center, spacing: 8) {
                    Text(Localization.productComplaintSubmissionTitle().uppercased())
                        .font(.title)


                    Text(Localization.preScanFormTitle().uppercased())
                        .font(.subheadline)
                }
                .multilineTextAlignment(.center)
                .padding()

                FormItemView(model: FormItemModel(icon: DesignSystem.Image.photo(), placeholder: Localization.productTitle()), text: $productTitle)
                    .focused($focusedField, equals: .productTitle)

                imageComponents

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
            case .cleanUp: cleanUp()
            case .updateLocalizations: updateLocalizations()
            }
        }
        .disabled(viewModel.isLoading)
        .alert(alertData.title, isPresented: $alertData.isPresented, actions: {
            Button(Localization.gotIt(), role: .cancel) { }
        })
        .onAppear {
            viewModel.viewDidAppear()
        }
    }

    private var imageComponents: some View {
        Group {
            ImageableView(model: $imageableModel0)
            ImageableView(model: $imageableModel1)
            ImageableView(model: $imageableModel2)
            ImageableView(model: $imageableModel3)
            ImageableView(model: $imageableModel4)
        }
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

    private func updateLocalizations() {
        imageableModel0.placeholderText = Localization.scanFirstImageDescription()
        imageableModel1.placeholderText = Localization.scanSecondImageDescription()
        imageableModel2.placeholderText = Localization.scanThirdImageDescription()
        imageableModel3.placeholderText = Localization.scanFourthImageDescription()
        imageableModel4.placeholderText = Localization.scanFifthImageDescription()
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

// MARK: - Fields
private extension ProductComplaintSubmissionView {
    enum Field: Arrangeable {
        case productTitle
        case fullName
        case comment
        case location

        var arranged: [Field] {
            [.productTitle, .fullName, .comment, .location]
        }
    }
}

// MARK: - Previews
struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ProductComplaintSubmissionView(viewModel: ProductComplaintSubmissionViewModel())
    }
}
