//
//  miet_practice_application_unit_tests.swift
//  miet-practice-application_unit_tests
//
//  Created by Egor Geronin on 23.11.2025.
//

import XCTest

final class UnitCaseWithAllTypes: XCTestCase {
    func test_success() async throws {
        XCTAssertTrue(true)
    }

    func test_skipped() async throws {
        throw XCTSkip()
    }

    func test_failure() async throws {
        XCTAssertTrue(false)
    }
}
