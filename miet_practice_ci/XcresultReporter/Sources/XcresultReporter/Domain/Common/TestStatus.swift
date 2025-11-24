//
//  TestStatus.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation

public enum TestStatus: Codable {
    /// Неизвестный статус
    case unknown
    /// Успех
    case success
    /// Пропуск
    case skipped
    /// Ошибка
    case failure
}
