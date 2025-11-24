//
//  TestSuite.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//
import Foundation

public struct TestSuite: Codable {
    /// Тип набора тестов
    let type: TestFramework
    /// Везанки наборов тестов
    let cases: [TestCase]

    public init(
        type: TestFramework,
        cases: [TestCase]
    ) {
        self.type = type
        self.cases = cases
    }
}
