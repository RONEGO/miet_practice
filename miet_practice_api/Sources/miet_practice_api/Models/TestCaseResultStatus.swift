import Fluent
import Vapor

/// Справочник результатов теста
final class TestCaseResultStatus: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testCaseResultStatus.rawValue

    /// Код статуса результата теста (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UUID?
    
    /// Значение статуса
    @Field(key: "value") var value: String

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}
