//
//  TestFrameworkDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//
import Vapor

public enum TestFrameworkDTO: String, Content {
    /// Неизвестный
    case unknown
    /// UI-тесты
    case xctestUI = "xctest_ui"
    /// Unit-тесты
    case xctestUnit = "xctest_unit"
}

