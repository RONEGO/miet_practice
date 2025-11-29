//
//  TestDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation
import Vapor

public struct TestDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case name
        case statusCode = "status_code"
        case duration
    }

    /// Название теста
    public let name: String
    /// Статус теста
    public let statusCode: TestStatusDTO
    /// Длительность прохождения теста
    public let duration: Double?

    public init(
        name: String,
        statusCode: TestStatusDTO,
        duration: Double?
    ) {
        self.name = name
        self.statusCode = statusCode
        self.duration = duration
    }
}

