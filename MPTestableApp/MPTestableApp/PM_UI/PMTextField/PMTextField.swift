//
//  PMTextField.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

struct PMTextField: View {

    // Environment

    @Environment(\.pmTextFieldIsSecure) private var isSecureField

    // Properties

    /// Подпись
    private let captionText: String
    /// Текст ввода
    @Binding private var inputText: String
    /// Сфокусирован ли ввод текста
    @FocusState private var isFocused: Bool
    /// Неймспейс подписи
    @Namespace private var captionNamespace
    /// Включена ли защита поля
    @State private var isSecureEnabled = true

    init(
        captionText: String,
        inputText: Binding<String>
    ) {
        self.captionText = captionText
        _inputText = inputText
    }

    var body: some View {
        let textFirst = (isFocused || !inputText.isEmpty)
        let layout = textFirst
        ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
        : AnyLayout(ZStackLayout(alignment: .leading))

        layout {
            Text(captionText)
                .pmForegroundColor(.textSecondaryTransparent)
                .font(.system(size: textFirst ? 16 : 24, weight: .light))
                .matchedGeometryEffect(id: "caption", in: captionNamespace)
                .allowsHitTesting(false)
            HStack {
                Group {
                    if isSecureEnabled && isSecureField {
                        SecureField("", text: $inputText)
                    } else {
                        TextField("", text: $inputText)
                    }
                }
                .font(.system(size: 24, weight: .bold))
                .focused($isFocused)

                if !inputText.isEmpty && isSecureField {
                    Image(systemName: isSecureEnabled ? "eye.circle.fill" : "eye.slash.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isSecureEnabled.toggle()
                        }
                }
            }
            .pmForegroundColor(.textPrimary)
        }
        .animation(.easeOut(duration: 0.1), value: isFocused)
        .animation(.easeOut(duration: 0.1), value: inputText.isEmpty)
    }
}
