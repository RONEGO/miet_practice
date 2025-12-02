//
//  TestFramework.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

enum TestFramework {
    case unknown
    case xctestUI
    case xctestUnit
    
    init(from dto: TestFrameworkDTO) {
        switch dto {
        case .unknown:
            self = .unknown
        case .xctestUI:
            self = .xctestUI
        case .xctestUnit:
            self = .xctestUnit
        }
    }
}

