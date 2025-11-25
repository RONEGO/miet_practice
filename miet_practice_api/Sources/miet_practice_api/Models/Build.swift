import Fluent
import Vapor

/// Сборки/прогоны тестов по коммитам
final class Build: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.build.rawValue

    /// Уникальный идентификатор сборки (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Связь со статусом сборки
    @Parent(key: "status_code") var status: BuildStatus
    
    /// Связь с задачей, к которой относится сборка
    @OptionalParent(key: "task_id") var task: Task?
    
    /// Git ветка, на которой выполняется сборка
    @Field(key: "git_branch") var gitBranch: String
    
    /// Время начала сборки
    @Timestamp(key: "started_at", on: .create) var startedAt: Date?
    
    /// Время окончания сборки
    @OptionalField(key: "ended_at") var endedAt: Date?
    
    /// Длительность сборки в миллисекундах
    @OptionalField(key: "duration") var duration: Int64?

    init() { }

    init(id: UUID? = nil, gitBranch: String, statusCode: BuildStatus.IDValue) {
        self.id = id
        self.gitBranch = gitBranch
        self.$status.id = statusCode
    }
}
