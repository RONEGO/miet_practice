//
//  RunEndpoint.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import MPDTO
import MPCore
import Foundation

struct RunEndpoint: Endpoint {
    typealias Request = RunBuildRequestDTO
    typealias Response = RunBuildResponseDTO

    let taskID: String?
    let gitBranch: String?

    /// Запрос
    var request: RunBuildRequestDTO {
        RunBuildRequestDTO(
            taskId: taskID.toUUID(),
            gitBranch: gitBranch
        )
    }

    /// Путь
    var path: String { "/v1/builds/run" }

    /// HTTP метод
    var httpMethod: HTTPMethod { .post }

}
