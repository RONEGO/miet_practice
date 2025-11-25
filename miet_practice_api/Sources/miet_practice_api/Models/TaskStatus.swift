import Fluent
import Vapor

/// Справочник статусов задачи
final class TaskStatus: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.taskStatus.rawValue

    /// Код статуса задачи (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UUID?
    
    /// Значение статуса
    @Field(key: "value") var value: String

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}
