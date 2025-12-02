//
//  MPTestableApp_ui_tests.swift
//  MPTestableAppUITests
//
//  Created by Egor Geronin on 23.11.2025.
//

import XCTest

final class UITestCase: XCTestCase {

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(false)
    }
}
