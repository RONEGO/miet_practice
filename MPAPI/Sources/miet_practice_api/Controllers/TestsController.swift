import Fluent
import Vapor
import MPDTO

struct TestsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let tests = routes.grouped("v1", "tests")
        tests.post("submit", use: update)
    }
    
    /// POST /v1/tests/update
    /// Обновляет или создает результаты тестов для сборки
    func update(req: Request) async throws -> SubmitTestResultsResponseDTO {
        let request = try req.content.decode(SubmitTestResultsRequestDTO.self)
        
        // Проверяем существование сборки
        guard try await Build.find(request.buildId, on: req.db) != nil else {
            throw Abort(.notFound, reason: "Build with id \(request.buildId) not found")
        }
        
        // Обрабатываем каждый набор тестов
        for testSuiteDTO in request.testSuites {
            // Преобразуем TestSuiteDTO в TestSuiteResult модель
            let frameworkEnum = BuildsMapper.mapTestFrameworkDTO(testSuiteDTO.type)
            let frameworkCode = try TestFramework.getCode(frameworkEnum.rawValue)
            
            // Ищем существующий TestSuiteResult по build_id, name и framework_code
            let existingSuite = try await TestSuiteResult.query(on: req.db)
                .filter(\.$build.$id == request.buildId)
                .filter(\.$name == testSuiteDTO.name)
                .filter(\.$framework.$id == frameworkCode)
                .first()
            
            let testSuite: TestSuiteResult
            if let existing = existingSuite {
                // Обновляем существующий
                testSuite = existing
                testSuite.name = testSuiteDTO.name
                testSuite.$framework.id = frameworkCode
                testSuite.$build.id = request.buildId
            } else {
                // Создаем новый
                testSuite = try BuildsMapper.mapTestSuiteDTOToModel(
                    testSuiteDTO,
                    buildId: request.buildId
                )
            }
            try await testSuite.save(on: req.db)
            
            guard let suiteId = testSuite.id else {
                throw Abort(.internalServerError, reason: "Failed to generate test suite ID")
            }
            
            // Обрабатываем каждый тест-кейс
            for testCaseDTO in testSuiteDTO.cases {
                // Ищем существующий TestCaseResult по suite_id и name
                let existingCase = try await TestCaseResult.query(on: req.db)
                    .filter(\.$suite.$id == suiteId)
                    .filter(\.$name == testCaseDTO.name)
                    .first()
                
                let testCase: TestCaseResult
                if let existing = existingCase {
                    // Обновляем существующий
                    testCase = existing
                    testCase.name = testCaseDTO.name
                    testCase.duration = Int64(testCaseDTO.duration * 1000)
                } else {
                    // Создаем новый
                    testCase = BuildsMapper.mapTestCaseDTOToModel(testCaseDTO, suiteId: suiteId)
                }
                try await testCase.save(on: req.db)
                
                guard let caseId = testCase.id else {
                    throw Abort(.internalServerError, reason: "Failed to generate test case ID")
                }
                
                // Обрабатываем каждый тест
                for testDTO in testCaseDTO.tests {
                    // Преобразуем TestStatusDTO в TestStatusEnum и получаем code
                    let statusEnum = BuildsMapper.mapTestStatusDTO(testDTO.statusCode)
                    let statusCode = try TestStatus.getCode(statusEnum.rawValue)
                    
                    // Ищем существующий TestResult по case_id и name
                    let existingTest = try await TestResult.query(on: req.db)
                        .filter(\.$testCase.$id == caseId)
                        .filter(\.$name == testDTO.name)
                        .first()
                    
                    let testResult: TestResult
                    if let existing = existingTest {
                        // Обновляем существующий
                        testResult = existing
                        testResult.name = testDTO.name
                        testResult.$status.id = statusCode
                        testResult.duration = testDTO.duration.map { Int64($0 * 1000) }
                    } else {
                        // Создаем новый
                        testResult = try BuildsMapper.mapTestDTOToModel(testDTO, caseId: caseId)
                    }
                    try await testResult.save(on: req.db)
                }
            }
        }
        
        return SubmitTestResultsResponseDTO(
            buildId: request.buildId,
            message: "Test results updated successfully",
            testSuitesCount: request.testSuites.count
        )
    }
}
