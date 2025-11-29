import Vapor

/// DTO для ответа на запрос запуска сборки
struct RunBuildResponseDTO: Content {
    enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
    }

    /// ID созданной сборки
    var buildId: UUID
}

