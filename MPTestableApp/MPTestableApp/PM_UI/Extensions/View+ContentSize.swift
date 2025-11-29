//
//  View+ContentSize.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmContentSize(_ onChange: @escaping (CGSize) -> Void) -> some View {
        modifier(ContentSizeModifier(onChange: onChange))
    }
}
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize? = nil

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = nextValue() ?? value
    }
}

private struct ContentSizeModifier: ViewModifier {
    let onChange: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { size in
                guard let size else { return }
                onChange(size)
            }
    }
}
