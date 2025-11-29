import Fluent
import Vapor

enum BuildStatusEnum: String, MPDictionaryEnum {
    /// В процессе сборки
    case running = "RUNNING"
    /// Успешная сборка
    case success = "SUCCESS"
    /// Провальная сборка
    case failure = "FAILURE"
    /// Неизвестный статус (fallback)
    case unknown = "UNKNOWN"
}

/// Справочник статусов сборок
final class BuildStatus: MPDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.buildStatus.rawValue

    /// Код статуса сборки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение статуса
    @Field(key: "value") var value: BuildStatusEnum

    init() { }

    init(code: Int? = nil, value: BuildStatusEnum) {
        self.id = id
        self.value = value
    }
}
