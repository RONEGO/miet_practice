//
//  UploadLogEndpoint.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import MPDTO
import Foundation
import Vapor

/// Endpoint для загрузки логов
struct UploadLogEndpoint: Endpoint {
    typealias Request = UploadLogRequestDTO
    typealias Response = UploadLogResponseDTO

    let testSuiteResultId: UUID
    let data: String
    let fileName: String

    /// Запрос с File, созданным из Data
    var request: UploadLogRequestDTO {
        UploadLogRequestDTO(
            log: File(data: data, filename: fileName)
        )
    }

    /// Путь
    var path: String { "/v1/test-suite/\(testSuiteResultId.uuidString)/log" }

    /// HTTP метод
    var httpMethod: HTTPMethod { .post }
}

