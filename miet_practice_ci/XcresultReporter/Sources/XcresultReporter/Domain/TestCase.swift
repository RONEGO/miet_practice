//
//  TestCase.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation

public struct TestCase: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case statusCode = "status_code"
        case duration
        case tests
    }

    /// Название тестов
    let name: String
    /// Статус тестов
    let statusCode: TestStatus
    /// Длительность прохождения тестов
    let duration: Double
    /// Тесты в вязанке
    let tests: [Test]

    public init(
        name: String,
        statusCode: TestStatus,
        duration: Double,
        tests: [Test]
    ) {
        self.name = name
        self.statusCode = statusCode
        self.duration = duration
        self.tests = tests
    }
}
