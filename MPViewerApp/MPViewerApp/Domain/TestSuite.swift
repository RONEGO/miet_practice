//
//  TestSuite.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

struct TestSuite {
    let name: String
    let type: TestFramework
    let cases: [TestCase]

    init(from dto: TestSuiteDTO) {
        self.name = dto.name
        self.type = TestFramework(from: dto.type)
        self.cases = dto.cases.map { TestCase(from: $0) }
    }
}

