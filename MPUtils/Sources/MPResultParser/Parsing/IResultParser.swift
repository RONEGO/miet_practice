//
//  IResultParser.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import XCResultKit
import MPDTO

public protocol IResultParser {
    /// Парсинг файла результатов тестов в домейн модель
    func parse(_ resultFile: XCResultFile) throws(ResultParserError) -> TestSuiteDTO
}
