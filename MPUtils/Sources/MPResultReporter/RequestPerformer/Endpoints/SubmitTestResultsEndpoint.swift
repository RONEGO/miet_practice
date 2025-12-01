//
//  SubmitTestResultsEndpoint.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import MPDTO
import Foundation

struct SubmitTestResultsEndpoint: Endpoint {
    typealias Request = SubmitTestResultsRequestDTO
    typealias Response = SubmitTestResultsResponseDTO

    let buildId: UUID
    let testSuites: [TestSuiteDTO]

    /// Запрос
    var request: SubmitTestResultsRequestDTO {
        SubmitTestResultsRequestDTO(
            buildId: buildId,
            testSuites: testSuites
        )
    }

    /// Путь
    var path: String { "/v1/tests/submit" }

    /// HTTP метод
    var httpMethod: HTTPMethod { .post }
}

