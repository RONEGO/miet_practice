import Vapor

/// DTO для запроса на отправку результатов тестов
public struct SubmitTestResultsRequestDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case testSuite = "test_suite"
    }
    
    /// ID сборки
    public var buildId: UUID
    
    /// Набор тестов
    public var testSuite: TestSuiteDTO
    
    public init(buildId: UUID, testSuite: TestSuiteDTO) {
        self.buildId = buildId
        self.testSuite = testSuite
    }
}

