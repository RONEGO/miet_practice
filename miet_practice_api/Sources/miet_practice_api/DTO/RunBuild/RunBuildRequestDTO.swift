import Vapor

/// DTO для запроса на запуск сборки
struct RunBuildRequestDTO: Content {
    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case gitBranch = "git_branch"
    }

    /// ID задачи (опционально)
    var taskId: UUID?
    
    /// Git ветка (опционально)
    var gitBranch: String?
}

