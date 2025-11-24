//
//  IXcresultParser.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import XCResultKit

public protocol IXcresultParser {
    /// Парсинг файла результатов тестов в домейн модель
    func parse(_ resultFile: XCResultFile) throws(XcresultParserError) -> TestSuite
}
