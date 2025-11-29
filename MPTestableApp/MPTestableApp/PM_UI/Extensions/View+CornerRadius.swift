//
//  View+CornerRadius.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

extension View {
    func pmCornerRadius(_ bit: PMBit, corners: UIRectCorner) -> some View {
        clipShape(PMRoundedCorner(bit: bit, corners: corners))
    }
}

private struct PMRoundedCorner: Shape {
    let bit: PMBit
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: bit.rawValue, height: bit.rawValue)
        )
        return Path(path.cgPath)
    }
}
