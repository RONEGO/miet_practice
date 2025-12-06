import Fluent
import Vapor
import MPDTO

struct TestsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let testSuite = routes.grouped("v1", "test-suite")
        testSuite.post("submit", use: update)
        testSuite.post(":test_suite_result_id", "log", use: uploadLog)
        testSuite.get(":test_suite_result_id", "log", use: getLog)
    }
    
    /// POST /v1/test-suite/submit
    /// Обновляет или создает результаты тестов для сборки
    func update(req: Request) async throws -> SubmitTestResultsResponseDTO {
        let request = try req.content.decode(SubmitTestResultsRequestDTO.self)
        
        // Проверяем существование сборки
        guard try await Build.find(request.buildId, on: req.db) != nil else {
            throw Abort(.notFound, reason: "Сборка с id \(request.buildId) не найдена")
        }
        
        // Преобразуем TestSuiteDTO в TestSuiteResult модель
        let frameworkEnum = BuildsMapper.mapTestFrameworkDTO(request.testSuite.type)
        let frameworkCode = try TestFramework.getCode(frameworkEnum.rawValue)
        
        // Ищем существующий TestSuiteResult по build_id, name и framework_code
        let existingSuite = try await TestSuiteResult.query(on: req.db)
            .filter(\.$build.$id == request.buildId)
            .filter(\.$name == request.testSuite.name)
            .filter(\.$framework.$id == frameworkCode)
            .first()
        
        let testSuite: TestSuiteResult
        if let existing = existingSuite {
            // Обновляем существующий
            testSuite = existing
            testSuite.name = request.testSuite.name
            testSuite.$framework.id = frameworkCode
            testSuite.$build.id = request.buildId
        } else {
            // Создаем новый
            testSuite = try BuildsMapper.mapTestSuiteDTOToModel(
                request.testSuite,
                buildId: request.buildId
            )
        }
        try await testSuite.save(on: req.db)
        
        guard let suiteId = testSuite.id else {
            throw Abort(.internalServerError, reason: "Не удалось сгенерировать ID набора тестов")
        }
        
        // Обрабатываем каждый тест-кейс
        for testCaseDTO in request.testSuite.cases {
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
                throw Abort(.internalServerError, reason: "Не удалось сгенерировать ID тест-кейса")
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
        
        return SubmitTestResultsResponseDTO(
            buildId: request.buildId,
            message: "Результаты тестов успешно обновлены",
            testSuiteId: suiteId
        )
    }
    
    /// POST /v1/test-suite/{test_suite_result_id}/log
    /// Загружает файлы логов для набора тестов
    func uploadLog(req: Request) async throws -> UploadLogResponseDTO {
        // Получаем test_suite_result_id из параметров маршрута
        guard let testSuiteResultIdString = req.parameters.get("test_suite_result_id"),
              let testSuiteResultId = UUID(uuidString: testSuiteResultIdString) else {
            throw Abort(.badRequest, reason: "Неверный test_suite_result_id")
        }
        
        // Проверяем существование TestSuiteResult
        guard try await TestSuiteResult.find(testSuiteResultId, on: req.db) != nil else {
            throw Abort(.notFound, reason: "Результат набора тестов с id \(testSuiteResultId) не найден")
        }
        
        // Декодируем запрос с файлом
        let request = try req.content.decode(UploadLogRequestDTO.self)
        
        // Создаем или находим артефакт
        let existingArtefact = try await TestSuiteResultArtefact.query(on: req.db)
            .filter(\.$testSuiteResult.$id == testSuiteResultId)
            .first()
        
        let artefact: TestSuiteResultArtefact
        let artefactId: UUID
        
        if let existing = existingArtefact {
            // Используем существующий артефакт
            artefact = existing
            guard let id = existing.id else {
                throw Abort(.internalServerError, reason: "ID артефакта отсутствует")
            }
            artefactId = id
        } else {
            // Создаем новый артефакт
            let newId = UUID()
            artefact = TestSuiteResultArtefact(
                id: newId,
                testSuiteResultID: testSuiteResultId,
                logsUrl: nil
            )
            try await artefact.save(on: req.db)
            artefactId = newId
        }
        
        // Создаем директорию для логов, если её нет
        let workingDirectory = req.application.directory.workingDirectory
        let uploadsDirectory = UploadPaths.testSuitesResultArtefactsPathWithSlash(
            workingDirectory: workingDirectory
        )

        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: uploadsDirectory) else {
            throw Abort(.internalServerError, reason: "Директория для загрузки отсутствует")
        }
        
        // Сохраняем файл с именем {artefact_id}.log
        let fileName = UploadPaths.logFileName(artefactId: artefactId)
        let filePath = uploadsDirectory + fileName
        
        // Сохраняем файл
        let data = Data(buffer: request.log.data)
        try data.write(to: URL(fileURLWithPath: filePath))
        
        // Обновляем URL логов в артефакте
        let logsUrl = UploadPaths.logFileRelativePath(artefactId: artefactId)
        artefact.logsUrl = logsUrl
        try await artefact.save(on: req.db)
        
        return UploadLogResponseDTO(
            testSuiteResultId: testSuiteResultId,
            artefactId: artefactId,
            message: "Файл лога успешно загружен",
            logsUrl: logsUrl
        )
    }
    
    /// GET /v1/test-suite/{test_suite_result_id}/log
    /// Получает файл лога для набора тестов
    func getLog(req: Request) async throws -> Response {
        // Получаем test_suite_result_id из параметров маршрута
        guard let testSuiteResultIdString = req.parameters.get("test_suite_result_id"),
              let testSuiteResultId = UUID(uuidString: testSuiteResultIdString) else {
            throw Abort(.badRequest, reason: "Неверный test_suite_result_id")
        }
        
        // Проверяем существование TestSuiteResult
        guard try await TestSuiteResult.find(testSuiteResultId, on: req.db) != nil else {
            throw Abort(.notFound, reason: "Результат набора тестов с id \(testSuiteResultId) не найден")
        }
        
        // Находим артефакт
        guard let artefact = try await TestSuiteResultArtefact.query(on: req.db)
            .filter(\.$testSuiteResult.$id == testSuiteResultId)
            .first() else {
            throw Abort(.notFound, reason: "Файл лога не найден для результата набора тестов с id \(testSuiteResultId)")
        }
        
        // Проверяем наличие logsUrl
        guard let logsUrl = artefact.logsUrl, !logsUrl.isEmpty else {
            throw Abort(.notFound, reason: "URL файла лога не установлен для результата набора тестов с id \(testSuiteResultId)")
        }
        
        // Формируем полный путь к файлу
        let workingDirectory = req.application.directory.workingDirectory
        let filePath = "\(workingDirectory)/\(logsUrl)"
        
        // Проверяем существование файла
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            throw Abort(.notFound, reason: "Файл лога не найден по пути: \(logsUrl)")
        }
        
        // Читаем файл
        let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
        
        // Создаем ответ с файлом
        var headers = HTTPHeaders()
        headers.contentType = .plainText
        headers.add(
            name: .contentDisposition,
            value: "attachment; filename=\"\(artefact.id?.uuidString ?? "log").log\""
        )

        return Response(
            status: .ok,
            headers: headers,
            body: Response.Body(data: fileData)
        )
    }
}
