//
//  UIView+PMColor.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmForegroundColor(_ colorStyle: PMForegroundColorStyle) -> some View {
        modifier(PMForegroundColorModifier(colorStyle: colorStyle))
    }
}

private struct PMForegroundColorModifier: ViewModifier {
    @Environment(\.pmColorScheme) var colorScheme
    @Environment(\.pmColorSchemeReversed) var colorSchemeReversed

    let colorStyle: PMForegroundColorStyle

    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorStyle.map(
                scheme: colorScheme,
                reversed: colorSchemeReversed
            ))
    }
}
