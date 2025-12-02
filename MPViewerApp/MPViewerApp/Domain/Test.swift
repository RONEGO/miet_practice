//
//  Test.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

struct Test {
    let name: String
    let statusCode: TestStatus
    let duration: Double?
    
    init(from dto: TestDTO) {
        self.name = dto.name
        self.statusCode = TestStatus(from: dto.statusCode)
        self.duration = dto.duration
    }
}

