//
//  PMButton.swift
//  miet_practice_application
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

struct PMButton: View {
    /// Текст в кнопке
    private let title: any StringProtocol
    /// Экшен нажатия
    private let onTap: () -> Void

    init<S>(
        title: S,
        onTap: @escaping () -> Void
    ) where S: StringProtocol {
        self.title = title
        self.onTap = onTap
    }

    var body: some View {
        Button {
            onTap()
        } label: {
            label
        }
    }

    private var label: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .pmPaddings(.bit8)
            .pmForegroundColor(.textPrimary)
            .pmBackgroundColor(.backgroundPrimary)
            .pmColorSchemeReversed(true)
            .pmCornerRadius(.bit8, corners: .allCorners)
    }
}
