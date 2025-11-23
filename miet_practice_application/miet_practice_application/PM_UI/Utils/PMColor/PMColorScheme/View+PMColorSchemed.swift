//
//  View+PMColorSchemed.swift
//  miet_practice_application
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmColorSchemed() -> some View {
        modifier(PMColorSchemedModifier())
    }
}

private struct PMColorSchemedModifier: ViewModifier {

    @Environment(\.colorScheme) private var systemScheme

    func body(content: Content) -> some View {
        content
            .environment(\.pmColorScheme, map(system: systemScheme))
    }

    func map(system: ColorScheme) -> PMColorScheme {
        switch system {
        case .dark: .dark
        case .light: .light
        @unknown default: .light
        }
    }
}
