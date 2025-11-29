//
//  TestCaseDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation
import Vapor

public struct TestCaseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case name
        case statusCode = "status_code"
        case duration
        case tests
    }

    /// Название тестов
    public let name: String
    /// Статус тестов
    public let statusCode: TestStatusDTO
    /// Длительность прохождения тестов
    public let duration: Double
    /// Тесты в вязанке
    public let tests: [TestDTO]

    public init(
        name: String,
        statusCode: TestStatusDTO,
        duration: Double,
        tests: [TestDTO]
    ) {
        self.name = name
        self.statusCode = statusCode
        self.duration = duration
        self.tests = tests
    }
}

