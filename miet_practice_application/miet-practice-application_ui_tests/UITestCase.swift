//
//  miet_practice_application_ui_tests.swift
//  miet-practice-application_ui_tests
//
//  Created by Egor Geronin on 23.11.2025.
//

import XCTest

final class UITestCase: XCTestCase {

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
