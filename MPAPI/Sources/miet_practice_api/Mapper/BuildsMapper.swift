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
}
