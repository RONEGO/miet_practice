import Vapor

/// DTO для ответа на запрос завершения сборки
struct CompleteBuildResponseDTO: Content {
    enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case message = "message"
    }
    
    /// ID сборки
    var buildId: UUID
    
    /// Сообщение о результате
    var message: String
}

