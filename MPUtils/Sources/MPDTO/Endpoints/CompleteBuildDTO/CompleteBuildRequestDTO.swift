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
    public var buildStatus: String
    
    public init(buildId: UUID, buildStatus: String) {
        self.buildId = buildId
        self.buildStatus = buildStatus
    }
}

