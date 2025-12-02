//
//  Endpoints.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation

enum Endpoints {
    static let baseURL = "http://127.0.0.1:8080"
    
    static func builds() -> String {
        "\(baseURL)/v1/builds"
    }
    
    static func testSuiteLog(testSuiteResultId: UUID) -> String {
        "\(baseURL)/v1/test-suite/\(testSuiteResultId.uuidString)/log"
    }
}

