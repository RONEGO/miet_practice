import Fluent
import Vapor

/// Задачи на ручную проверку/регрессию
final class Task: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.task.rawValue

    /// Уникальный идентификатор задачи (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Исполнитель задачи
    @OptionalParent(key: "assignee_id") var assignee: User?
    
    /// QA специалист, назначенный на задачу
    @OptionalParent(key: "qa_id") var qa: User?
    
    /// Связь со статусом задачи
    @Parent(key: "status_code") var status: TaskStatus
    
    /// Дата завершения задачи
    @OptionalField(key: "completed_at") var completedAt: Date?
    
    /// Дата создания задачи
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    init() { }

    init(id: UUID? = nil, statusCode: TaskStatus.IDValue) {
        self.id = id
        self.$status.id = statusCode
    }
}
