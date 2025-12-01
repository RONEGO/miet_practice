//
//  TestSuiteDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation
import Vapor

public struct TestSuiteDTO: Content {
    /// Название набора тестов
    public let name: String
    /// Тип набора тестов
    public let type: TestFrameworkDTO
    /// Везанки наборов тестов
    public let cases: [TestCaseDTO]

    public init(
        name: String,
        type: TestFrameworkDTO,
        cases: [TestCaseDTO]
    ) {
        self.name = name
        self.type = type
        self.cases = cases
    }
}

