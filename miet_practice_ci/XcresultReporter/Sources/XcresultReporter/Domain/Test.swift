//
//  Test.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation

public struct Test: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case statusCode = "status_code"
        case duration
    }

    /// Название теста
    let name: String
    /// Статус теста
    let statusCode: TestStatus
    /// Длительность прохождения теста
    let duration: Double?

    public init(
        name: String,
        statusCode: TestStatus,
        duration: Double?
    ) {
        self.name = name
        self.statusCode = statusCode
        self.duration = duration
    }
}
