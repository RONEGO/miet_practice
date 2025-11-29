//
//  EnvironmentValues+PMTextField.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

// isSecure

extension EnvironmentValues {
    var pmTextFieldIsSecure: Bool {
        get { self[PMTextFieldIsSecureEnvironmentKey.self] }
        set { self[PMTextFieldIsSecureEnvironmentKey.self] = newValue }
    }
}

extension View {
    func pmTextField(isSecure: Bool) -> some View {
        environment(\.pmTextFieldIsSecure, isSecure)
    }
}

private struct PMTextFieldIsSecureEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
