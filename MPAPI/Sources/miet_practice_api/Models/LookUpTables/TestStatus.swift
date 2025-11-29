import Fluent
import Vapor

enum TestStatusEnum: String, LookUpTableEnum {
    /// Тест пройден
    case success = "SUCCESS"
    /// Тест провален
    case failure = "FAILURE"
    /// Тест пропущен
    case skipped = "SKIPPED"
    /// Неизвестный статус (fallback)
    case unknown = "UNKNOWN"
}

/// Справочник результатов теста
final class TestStatus: LookUpTable, @unchecked Sendable {
    static let schema = DatabaseSchema.testResultStatus.rawValue

    /// Код статуса результата теста (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UInt8?

    /// Значение статуса
    @Field(key: "value") var value: TestStatusEnum

    init() { }

    init(id: UInt8?, value: TestStatusEnum) {
        self.id = id
        self.value = value
    }
}

