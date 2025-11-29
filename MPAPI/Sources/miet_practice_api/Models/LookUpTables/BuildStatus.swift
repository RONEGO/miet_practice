import Fluent
import Vapor

enum BuildStatusEnum: String, LookUpTableEnum {
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
final class BuildStatus: LookUpTable, @unchecked Sendable {
    static let schema = DatabaseSchema.buildStatus.rawValue

    /// Код статуса сборки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UInt8?

    /// Значение статуса
    @Field(key: "value") var value: BuildStatusEnum

    init() { }

    init(id: UInt8?, value: BuildStatusEnum) {
        self.id = id
        self.value = value
    }
}
