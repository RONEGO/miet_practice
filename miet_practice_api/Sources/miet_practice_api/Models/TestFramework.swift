import Fluent
import Vapor

/// Справочник библиотек тестов
final class TestFramework: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testFramework.rawValue

    /// Код фреймворка тестирования (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UUID?
    
    /// Значение фреймворка
    @Field(key: "value") var value: String

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}

