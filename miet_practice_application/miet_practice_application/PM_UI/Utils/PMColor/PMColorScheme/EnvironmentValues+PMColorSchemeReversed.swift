//
//  EnvironmentValues+PMColorScheme.swift
//  miet_practice_application
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmColorSchemeReversed(_ value: Bool) -> some View {
        environment(\.pmColorSchemeReversed, value)
    }
}

private struct PMColorSchemeReversedKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var pmColorSchemeReversed: Bool {
        get { self[PMColorSchemeReversedKey.self] }
        set { self[PMColorSchemeReversedKey.self] = newValue }
    }
}
