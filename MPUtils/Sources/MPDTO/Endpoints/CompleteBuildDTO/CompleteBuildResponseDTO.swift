import Vapor

/// DTO для ответа на запрос завершения сборки
public struct CompleteBuildResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case message = "message"
    }
    
    /// ID сборки
    public var buildId: UUID
    
    /// Сообщение о результате
    public var message: String
    
    public init(buildId: UUID, message: String) {
        self.buildId = buildId
        self.message = message
    }
}

