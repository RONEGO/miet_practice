//
//  BuildInfo.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO


struct BuildInfo: Identifiable {
    let id: UUID
    let status: BuildInfoStatus
    let testSuites: [TestSuite]
    
    init(from dto: GetBuildsResponseDTO.BuildInfoDTO) {
        self.id = dto.buildId
        self.status = BuildInfoStatus(rawValue: dto.buildStatus) ?? .unknown
        self.testSuites = dto.testSuites.map { TestSuite(from: $0) }
    }
}

enum BuildInfoStatus: String {
    /// В процессе сборки
    case running = "RUNNING"
    /// Успешная сборка
    case success = "SUCCESS"
    /// Провальная сборка
    case failure = "FAILURE"
    /// Неизвестный статус (fallback)
    case unknown = "UNKNOWN"
}
