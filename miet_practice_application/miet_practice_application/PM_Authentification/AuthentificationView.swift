//
//  ContentView.swift
//  miet_practice_application
//
//  Created by Egor Geronin on 22.11.2025.
//

import SwiftUI

struct AuthentificationView: View {
    @Environment(\.pmColorScheme) private var colorScheme: PMColorScheme

    @StateObject private var viewModel = AuthentificationViewModel()

    private var icon: String {
        switch colorScheme {
        case .light:
            "logo_icon_light"
        case .dark:
            "logo_icon_dark"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                scrollView
                footer
            }
            .pmBackgroundColor(.backgroundPrimary)
            .navigationTitle(String(localized: "Authentification"))
        }
    }

    var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.size.width / 2)
                    .pmPaddings(.bit4, edges: .bottom)

                PMTextField(
                    captionText: String(localized: "Login"),
                    inputText: $viewModel.viewState.loginText
                )

                PMTextField(
                    captionText: String(localized: "Password"),
                    inputText: $viewModel.viewState.passwordText
                )
                .pmTextField(isSecure: true)
            }
            .pmPaddings(.bit8, edges: .horizontal)
            .pmPaddings(.bit4, edges: .top)
        }
    }

    var footer: some View {
        PMButton(title: "Sing up") {
            viewModel.handle(.didTapSignIn)
        }
        .pmPaddings(.bit8)
        .pmBackgroundColor(.backgroundPrimary)
        .pmCornerRadius(.bit16, corners: [.topLeft, .topRight])
    }
}
