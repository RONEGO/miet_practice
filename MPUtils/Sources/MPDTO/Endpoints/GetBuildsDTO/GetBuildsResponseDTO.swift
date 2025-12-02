import Foundation
import Vapor

/// DTO для ответа на запрос получения всех сборок
public struct GetBuildsResponseDTO: Content {
    public enum CodingKeys: String, CodingKey {
        case builds
        case pagination
    }
    
    /// Массив сборок с их тестами
    public let builds: [BuildInfoDTO]
    
    /// Метаданные пагинации
    public let pagination: PaginationInfoDTO
    
    public init(builds: [BuildInfoDTO], pagination: PaginationInfoDTO) {
        self.builds = builds
        self.pagination = pagination
    }
}

extension GetBuildsResponseDTO {
    /// Метаданные пагинации
    public struct PaginationInfoDTO: Content {
        public enum CodingKeys: String, CodingKey {
            case page
            case perPage = "per_page"
        }
        
        /// Текущая страница (начиная с 1)
        public let page: Int
        
        /// Количество элементов на странице
        public let perPage: Int

        public init(page: Int, perPage: Int) {
            self.page = page
            self.perPage = perPage
        }
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

