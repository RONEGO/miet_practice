import Vapor

/// DTO для ответа на запрос отправки результатов тестов
public struct SubmitTestResultsResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case message
        case testSuitesCount = "test_suites_count"
    }
    
    /// ID сборки
    public var buildId: UUID
    
    /// Сообщение о результате
    public var message: String
    
    /// Количество обработанных наборов тестов
    public var testSuitesCount: Int
    
    public init(buildId: UUID, message: String, testSuitesCount: Int) {
        self.buildId = buildId
        self.message = message
        self.testSuitesCount = testSuitesCount
    }
}

