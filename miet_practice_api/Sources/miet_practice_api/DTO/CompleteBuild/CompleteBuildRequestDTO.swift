import Vapor

/// DTO для запроса на завершение сборки
struct CompleteBuildRequestDTO: Content {
    enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case buildStatus = "build_status"
    }
    
    /// ID сборки
    var buildId: UUID
    
    /// Статус завершения сборки (SUCCESS или FAILURE)
    var buildStatus: String
}

