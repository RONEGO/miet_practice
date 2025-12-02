//
//  TestCase.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

struct TestCase: Identifiable {
    var id: String { name }

    let name: String
    let statusCode: TestStatus
    let duration: Double
    let tests: [Test]
    
    init(from dto: TestCaseDTO) {
        self.name = dto.name
        self.statusCode = TestStatus(from: dto.statusCode)
        self.duration = dto.duration
        self.tests = dto.tests.map { Test(from: $0) }
    }
}

