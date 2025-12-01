import Vapor

/// DTO для ответа на запрос загрузки логов
public struct UploadLogResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case testSuiteResultId = "test_suite_result_id"
        case artefactId = "artefact_id"
        case message
        case logsUrl = "logs_url"
    }
    
    /// ID набора тестов
    public var testSuiteResultId: UUID
    
    /// ID созданного артефакта
    public var artefactId: UUID
    
    /// Сообщение о результате
    public var message: String
    
    /// URL загруженных логов
    public var logsUrl: String
    
    public init(testSuiteResultId: UUID, artefactId: UUID, message: String, logsUrl: String) {
        self.testSuiteResultId = testSuiteResultId
        self.artefactId = artefactId
        self.message = message
        self.logsUrl = logsUrl
    }
}

