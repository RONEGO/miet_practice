//
//  PMForegroundColorStyle+Schemed.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import UIKit

extension PMForegroundColorStyle: PMColorSchemable {
    var schemed: PMColorSchemed {
        switch self {
        case .textPrimary:
            PMColorSchemed(
                light: UIColor(hex: "#000000"),
                dark: UIColor(hex: "#FFFFFF")
            )
        case .textSecondaryTransparent:
            PMColorSchemed(
                light: UIColor(hex: "#00000050"),
                dark: UIColor(hex: "#FFFFFF50")
            )
        }
    }
}
