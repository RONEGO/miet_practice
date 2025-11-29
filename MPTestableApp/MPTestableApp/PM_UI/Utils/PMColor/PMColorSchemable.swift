//
//  PMColorSchemable.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import SwiftUI

protocol PMColorSchemable {
    var schemed: PMColorSchemed { get }
}

extension PMColorSchemable {
    func map(scheme: PMColorScheme, reversed: Bool) -> Color {
        let schemed = schemed
        let uiColor = switch scheme {
        case .light:
            reversed ? schemed.dark : schemed.light
        case .dark:
            reversed ? schemed.light : schemed.dark
        }
        return Color(uiColor: uiColor)
    }
}
