import Vapor

/// DTO для запроса на запуск сборки
public struct RunBuildRequestDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case gitBranch = "git_branch"
    }

    /// ID задачи (опционально)
    public var taskId: UUID?
    
    /// Git ветка (опционально)
    public var gitBranch: String?
    
    public init(taskId: UUID? = nil, gitBranch: String? = nil) {
        self.taskId = taskId
        self.gitBranch = gitBranch
    }
}

