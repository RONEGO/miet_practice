import Fluent
import Vapor

/// Результаты отдельных тест-кейсов
final class TestCaseResult: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testCaseResult.rawValue

    /// Уникальный идентификатор тест-кейса (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Связь с набором тестов
    @Parent(key: "suite_id") var suite: TestSuiteResult
    
    /// Название тест-кейса
    @Field(key: "name") var name: String
    
    /// Длительность выполнения тест-кейса в миллисекундах
    @OptionalField(key: "duration") var duration: Int64?

    init() { }

    init(id: UUID? = nil, name: String, suiteID: TestSuiteResult.IDValue) {
        self.id = id
        self.name = name
        self.$suite.id = suiteID
    }
}
