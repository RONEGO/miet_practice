//
//  EnvironmentValues+PMColorScheme.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmColorScheme(_ scheme: PMColorScheme) -> some View {
        environment(\.pmColorScheme, scheme)
    }
}

private struct PMColorSchemeKey: EnvironmentKey {
    static let defaultValue: PMColorScheme = .light
}

extension EnvironmentValues {
    var pmColorScheme: PMColorScheme {
        get { self[PMColorSchemeKey.self] }
        set { self[PMColorSchemeKey.self] = newValue }
    }
}
