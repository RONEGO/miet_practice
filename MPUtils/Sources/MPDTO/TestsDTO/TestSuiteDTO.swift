//
//  TestSuiteDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation
import Vapor

public struct TestSuiteDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case name
        case type
        case cases
        case testSuiteResultId = "test_suite_result_id"
    }
    
    /// Название набора тестов
    public let name: String
    /// Тип набора тестов
    public let type: TestFrameworkDTO
    /// Везанки наборов тестов
    public let cases: [TestCaseDTO]
    /// ID результата набора тестов
    public let testSuiteResultId: UUID?

    public init(
        name: String,
        type: TestFrameworkDTO,
        cases: [TestCaseDTO],
        testSuiteResultId: UUID? = nil
    ) {
        self.name = name
        self.type = type
        self.cases = cases
        self.testSuiteResultId = testSuiteResultId
    }
}

