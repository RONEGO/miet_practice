import Fluent
import Vapor

enum TestStatusEnum: String, Codable, Sendable, CaseIterable {
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
final class TestStatus: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testResultStatus.rawValue

    /// Код статуса результата теста (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение статуса
    @Field(key: "value") var value: TestStatusEnum

    init() { }

    init(id: Int? = nil, value: TestStatusEnum) {
        self.id = id
        self.value = value
    }
}

