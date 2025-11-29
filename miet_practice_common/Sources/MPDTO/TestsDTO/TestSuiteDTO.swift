//
//  TestSuiteDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation
import Vapor

public struct TestSuiteDTO: Content {
    /// Тип набора тестов
    public let type: TestFrameworkDTO
    /// Везанки наборов тестов
    public let cases: [TestCaseDTO]

    public init(
        type: TestFrameworkDTO,
        cases: [TestCaseDTO]
    ) {
        self.type = type
        self.cases = cases
    }
}

