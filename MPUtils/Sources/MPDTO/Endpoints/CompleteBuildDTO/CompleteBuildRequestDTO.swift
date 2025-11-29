import Vapor

/// DTO для запроса на завершение сборки
public struct CompleteBuildRequestDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case buildStatus = "build_status"
    }
    
    /// ID сборки
    public var buildId: UUID
    
    /// Статус завершения сборки (SUCCESS или FAILURE)
    public var buildStatus: BuildStatusDTO

    public init(buildId: UUID, buildStatus: BuildStatusDTO) {
        self.buildId = buildId
        self.buildStatus = buildStatus
    }
}

extension CompleteBuildRequestDTO {
    public enum BuildStatusDTO: String, Codable, Sendable {
        /// Удача
        case success = "SUCCESS"
        /// Неудача
        case failure = "FAILURE"
    }
}
