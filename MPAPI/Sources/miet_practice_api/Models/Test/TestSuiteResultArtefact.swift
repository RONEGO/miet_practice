import Fluent
import Vapor

/// Артефакты для наборов тестов
final class TestSuiteResultArtefact: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testSuiteResultArtefact.rawValue

    /// Уникальный идентификатор артефакта (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?

    /// Связь с набором тестов
    @Parent(key: "test_suite_result_id") var testSuiteResult: TestSuiteResult

    /// URL логов
    @OptionalField(key: "logs_url") var logsUrl: String?

    init() { }

    init(id: UUID? = nil, testSuiteResultID: TestSuiteResult.IDValue, logsUrl: String? = nil) {
        self.id = id
        self.$testSuiteResult.id = testSuiteResultID
        self.logsUrl = logsUrl
    }
}

