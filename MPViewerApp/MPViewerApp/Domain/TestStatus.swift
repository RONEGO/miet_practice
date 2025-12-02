//
//  TestStatus.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

enum TestStatus {
    case unknown
    case success
    case skipped
    case failure
    
    init(from dto: TestStatusDTO) {
        switch dto {
        case .unknown:
            self = .unknown
        case .success:
            self = .success
        case .skipped:
            self = .skipped
        case .failure:
            self = .failure
        }
    }
}

