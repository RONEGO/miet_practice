//
//  CompleteEndpoint.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import MPDTO
import Foundation

struct CompleteEndpoint: Endpoint {
    typealias Request = CompleteBuildRequestDTO
    typealias Response = CompleteBuildResponseDTO

    let buildId: UUID
    let buildStatus: CompleteBuildRequestDTO.BuildStatusDTO

    /// Запрос
    var request: CompleteBuildRequestDTO {
        CompleteBuildRequestDTO(
            buildId: buildId,
            buildStatus: buildStatus
        )
    }

    /// Путь
    var path: String { "/v1/builds/complete" }

    /// HTTP метод
    var httpMethod: HTTPMethod { .patch }
}

