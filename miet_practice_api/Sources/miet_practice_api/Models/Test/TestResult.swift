import Fluent
import Vapor

/// Результаты отдельных тестов
final class TestResult: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testResult.rawValue

    /// Уникальный идентификатор результата теста (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Связь с тест-кейсом
    @Parent(key: "case_id") var testCase: TestCaseResult
    
    /// Название теста
    @Field(key: "name") var name: String
    
    /// Связь со статусом результата теста
    @Parent(key: "status_code") var status: TestStatus
    
    /// Длительность выполнения теста в миллисекундах
    @OptionalField(key: "duration") var duration: Int64?

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        caseID: TestCaseResult.IDValue,
        statusCode: TestStatus.IDValue
    ) {
        self.id = id
        self.name = name
        self.$testCase.id = caseID
        self.$status.id = statusCode
    }
}

