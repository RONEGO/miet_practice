import Vapor

/// DTO для ответа на запрос отправки результатов тестов
public struct SubmitTestResultsResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case message
        case testSuiteId = "test_suite_id"
    }
    
    /// ID сборки
    public var buildId: UUID
    
    /// Сообщение о результате
    public var message: String
    
    /// ID обработанного набора тестов
    public var testSuiteId: UUID
    
    public init(buildId: UUID, message: String, testSuiteId: UUID) {
        self.buildId = buildId
        self.message = message
        self.testSuiteId = testSuiteId
    }
}

