import Vapor

/// DTO для ответа на запрос запуска сборки
public struct RunBuildResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
    }

    /// ID созданной сборки
    public var buildId: UUID
    
    public init(buildId: UUID) {
        self.buildId = buildId
    }
}

