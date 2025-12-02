//
//  BuildsMapper.swift
//  MPAPI
//
//  Created by Egor Geronin on 30.11.2025.
//

import Foundation
import Fluent
import MPDTO

enum BuildsMapper {
    // MARK: - BuildStatus Mapping
    
    /// Преобразует BuildStatusDTO в код статуса сборки
    static func mapBuildStatusDTOToCode(_ dto: CompleteBuildRequestDTO.BuildStatusDTO) throws -> UInt8 {
        switch dto {
        case .success:
            return try BuildStatus.getCode(.success)
        case .failure:
            return try BuildStatus.getCode(.failure)
        }
    }
    
    // MARK: - TestFramework Mapping
    
    /// Преобразует TestFrameworkDTO в TestFrameworkEnum
    static func mapTestFrameworkDTO(_ dto: TestFrameworkDTO) -> TestFrameworkEnum {
        switch dto {
        case .unknown:
            return .unknown
        case .xctestUI:
            return .xcodeUI
        case .xctestUnit:
            return .xcodeUnit
        }
    }
    
    /// Преобразует TestFrameworkDTO в TestSuiteResult модель
    static func mapTestSuiteDTOToModel(
        _ dto: TestSuiteDTO,
        buildId: UUID
    ) throws -> TestSuiteResult {
        let frameworkEnum = mapTestFrameworkDTO(dto.type)
        let frameworkCode = try TestFramework.getCode(frameworkEnum.rawValue)
        
        return TestSuiteResult(
            id: UUID(),
            name: dto.name,
            frameworkCode: frameworkCode,
            buildID: buildId
        )
    }
    
    // MARK: - TestCase Mapping
    
    /// Преобразует TestCaseDTO в TestCaseResult модель
    static func mapTestCaseDTOToModel(
        _ dto: TestCaseDTO,
        suiteId: UUID
    ) -> TestCaseResult {
        // Преобразуем duration из секунд в миллисекунды
        let durationMs = Int64(dto.duration * 1000)
        
        let testCase = TestCaseResult(
            id: UUID(),
            name: dto.name,
            suiteID: suiteId
        )
        testCase.duration = durationMs
        
        return testCase
    }
    
    // MARK: - TestStatus Mapping
    
    /// Преобразует TestStatusDTO в TestStatusEnum
    static func mapTestStatusDTO(_ dto: TestStatusDTO) -> TestStatusEnum {
        switch dto {
        case .unknown:
            return .unknown
        case .success:
            return .success
        case .skipped:
            return .skipped
        case .failure:
            return .failure
        }
    }
    
    // MARK: - TestResult Mapping
    
    /// Преобразует TestDTO в TestResult модель
    static func mapTestDTOToModel(
        _ dto: TestDTO,
        caseId: UUID
    ) throws -> TestResult {
        // Преобразуем TestStatusDTO в TestStatusEnum и получаем code
        let statusEnum = mapTestStatusDTO(dto.statusCode)
        let statusCode = try TestStatus.getCode(statusEnum.rawValue)
        
        // Преобразуем duration из секунд в миллисекунды (если есть)
        let testDurationMs = dto.duration.map { Int64($0 * 1000) }
        
        let testResult = TestResult(
            id: UUID(),
            name: dto.name,
            caseID: caseId,
            statusCode: statusCode
        )
        testResult.duration = testDurationMs
        
        return testResult
    }
    
    // MARK: - Reverse Mapping (Model to DTO)
    
    /// Преобразует TestFrameworkEnum в TestFrameworkDTO
    static func mapTestFrameworkEnumToDTO(_ enumValue: TestFrameworkEnum) -> TestFrameworkDTO {
        switch enumValue {
        case .unknown:
            return .unknown
        case .xcodeUI:
            return .xctestUI
        case .xcodeUnit:
            return .xctestUnit
        }
    }
    
    /// Преобразует TestStatusEnum в TestStatusDTO
    static func mapTestStatusEnumToDTO(_ enumValue: TestStatusEnum) -> TestStatusDTO {
        switch enumValue {
        case .unknown:
            return .unknown
        case .success:
            return .success
        case .skipped:
            return .skipped
        case .failure:
            return .failure
        }
    }
    
    /// Преобразует TestResult модель в TestDTO
    static func mapTestResultToDTO(_ model: TestResult, on database: Database) throws -> TestDTO {
        let statusDTO = mapTestStatusEnumToDTO(model.status.value)
        let duration = model.duration.map { Double($0) / 1000.0 } // Преобразуем из миллисекунд в секунды
        
        return TestDTO(
            name: model.name,
            statusCode: statusDTO,
            duration: duration
        )
    }
    
    /// Преобразует TestCaseResult модель в TestCaseDTO
    static func mapTestCaseResultToDTO(_ model: TestCaseResult, on database: Database) async throws -> TestCaseDTO {
        // Загружаем все тесты для этого кейса
        let testResults = try await TestResult.query(on: database)
            .filter(\.$testCase.$id == model.id!)
            .all()
        
        // Загружаем статусы для всех тестов
        for testResult in testResults {
            try await testResult.$status.load(on: database)
        }
        
        let tests = try testResults.map { try mapTestResultToDTO($0, on: database) }
        let duration = model.duration.map { Double($0) / 1000.0 } ?? 0.0 // Преобразуем из миллисекунд в секунды
        
        // Определяем статус кейса на основе статусов тестов
        let statusCode: TestStatusDTO
        if tests.isEmpty {
            statusCode = .unknown
        } else if tests.allSatisfy({ $0.statusCode == .success }) {
            statusCode = .success
        } else if tests.contains(where: { $0.statusCode == .failure }) {
            statusCode = .failure
        } else {
            statusCode = .skipped
        }
        
        return TestCaseDTO(
            name: model.name,
            statusCode: statusCode,
            duration: duration,
            tests: tests
        )
    }
    
    /// Преобразует TestSuiteResult модель в TestSuiteDTO
    static func mapTestSuiteResultToDTO(_ model: TestSuiteResult, on database: Database) async throws -> TestSuiteDTO {
        // Загружаем фреймворк
        try await model.$framework.load(on: database)
        let frameworkDTO = mapTestFrameworkEnumToDTO(model.framework.value)
        
        // Загружаем все тест-кейсы для этого сьюта
        let testCases = try await TestCaseResult.query(on: database)
            .filter(\.$suite.$id == model.id!)
            .all()
        
        // Преобразуем каждый кейс в DTO
        let cases = try await testCases.asyncMap { try await mapTestCaseResultToDTO($0, on: database) }
        
        return TestSuiteDTO(
            name: model.name,
            type: frameworkDTO,
            cases: cases
        )
    }
}

// Вспомогательное расширение для async map
extension Sequence {
    func asyncMap<T>(
        _ transform: @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        var results: [T] = []
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
}
