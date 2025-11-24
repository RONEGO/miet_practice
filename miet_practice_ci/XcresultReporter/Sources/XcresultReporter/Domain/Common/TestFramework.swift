//
//  TestFramework.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

public enum TestFramework: String, Codable {
    /// Неизвестный
    case unknown
    /// UI-тесты
    case xctestUI = "xctest_ui"
    /// Unit-тесты
    case xctestUnit = "xctest_unit"
}
