import Fluent
import Vapor

enum TaskStatusEnum: String, MPCodedDictionaryEnum {
    /// Новая задача
    case new = "NEW"
    /// В работе
    case inProgress = "IN_PROGRESS"
    /// На проверке
    case inReview = "IN_REVIEW"
    /// Выполнена
    case completed = "COMPLETED"
    /// Отменена
    case cancelled = "CANCELLED"
    /// Неизвестный статус (fallback)
    case unknown = "UNKNOWN"
}

/// Справочник статусов задачи
final class TaskStatus: MPCodedDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.taskStatus.rawValue

    /// Код статуса задачи (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение статуса
    @Field(key: "value") var value: TaskStatusEnum

    init() { }

    init(id: Int?, value: TaskStatusEnum) {
        self.id = id
        self.value = value
    }
}

