//
//  View+Paddings.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmPaddings(_ bit: PMBit, edges: Edge.Set = .all) -> some View {
        modifier(PMPaddingsModifier(bit: bit, edges: edges))
    }
}

private struct PMPaddingsModifier: ViewModifier {
    let bit: PMBit
    let edges: Edge.Set

    func body(content: Content) -> some View {
        content.padding(edges, bit.rawValue)
    }
}
