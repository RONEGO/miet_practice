import Foundation
import Vapor

/// DTO для ответа на запрос получения всех сборок
public struct GetBuildsResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case builds
    }

    /// Массив сборок с их тестами
    public let builds: [BuildInfoDTO]

    public init(builds: [BuildInfoDTO]) {
        self.builds = builds
    }
}

extension GetBuildsResponseDTO {
    /// Информация о сборке с тестами
    public struct BuildInfoDTO: Content {
        public enum CodingKeys: String, CodingKey {
            case buildId = "build_id"
            case buildStatus = "build_status"
            case testSuites = "test_suites"
        }
        
        /// ID сборки
        public let buildId: UUID
        
        /// Статус сборки
        public let buildStatus: String
        
        /// Массив всех сьютов, связанных с билдом
        public let testSuites: [TestSuiteDTO]
        
        public init(buildId: UUID, buildStatus: String, testSuites: [TestSuiteDTO]) {
            self.buildId = buildId
            self.buildStatus = buildStatus
            self.testSuites = testSuites
        }
    }
}

