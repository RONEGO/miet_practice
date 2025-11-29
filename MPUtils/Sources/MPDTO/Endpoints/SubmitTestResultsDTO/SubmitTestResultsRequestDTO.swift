import Vapor

/// DTO для запроса на отправку результатов тестов
public struct SubmitTestResultsRequestDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case buildId = "build_id"
        case testSuites = "test_suites"
    }
    
    /// ID сборки
    public var buildId: UUID
    
    /// Массив наборов тестов
    public var testSuites: [TestSuiteDTO]
    
    public init(buildId: UUID, testSuites: [TestSuiteDTO]) {
        self.buildId = buildId
        self.testSuites = testSuites
    }
}

