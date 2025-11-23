//
//  PMBackgroundColorStyle+Schemed.swift
//  miet_practice_application
//
//  Created by Egor Geronin on 23.11.2025.
//

import UIKit

extension PMBackgroundColorStyle: PMColorSchemable {
    var schemed: PMColorSchemed {
        switch self {
        case .backgroundPrimary:
            PMColorSchemed(
                light: UIColor(hex: "#FFFFFF"),
                dark: UIColor(hex: "#000000")
            )
        }
    }
}
