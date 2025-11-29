//
//  View+PMBackgroundColor.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmBackgroundColor(_ colorStyle: PMBackgroundColorStyle) -> some View {
        modifier(PMBackgroundColorModifier(colorStyle: colorStyle))
    }
}

private struct PMBackgroundColorModifier: ViewModifier {
    @Environment(\.pmColorScheme) var colorScheme
    @Environment(\.pmColorSchemeReversed) var colorSchemeReversed

    let colorStyle: PMBackgroundColorStyle

    func body(content: Content) -> some View {
        content
            .background(colorStyle.map(
                scheme: colorScheme,
                reversed: colorSchemeReversed
            ))
    }
}
