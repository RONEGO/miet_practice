//
//  MPResultReporter.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import ArgumentParser
import Foundation
import XCResultKit
import MPDTO
import MPCore

@main
struct MPResultReporter: AsyncParsableCommand {
    @Argument(help: "Base url for endpoints")
    var baseURL: String

    @Argument(help: "The path to a cache file where cache will be stored")
    var cacheFilePath: String

    @Flag(name: .customLong("run"), help: "Flag to run build")
    var runBuild: Bool = false
    
    @Flag(name: .customLong("complete"), help: "Flag to complete build")
    var complete: Bool = false
    
    @Flag(name: .customLong("submit-tests"), help: "Flag to submit test results")
    var submitTests: Bool = false

    // Опции для --run
    @Option(name: .customLong("task-id"), help: "Task ID (optional, only for --run)")
    var taskId: String?
    
    @Option(name: .customLong("git-branch"), help: "Git branch (optional, only for --run)")
    var gitBranch: String?

    @Option(name: .customLong("build-status"), help: "Build status (optional, only for --complete)")
    var buildStatus: String?
    
    @Option(name: .customLong("test-results-file"), help: "Path to test results JSON file (required for --submit-tests)")
    var testResultsFile: String?

    func run() async throws {
        guard let url = URL(string: baseURL) else {
            return
        }
        let perfomer = RequestPerformer(baseURL: url)
        
        if runBuild {
            try await sendRunRequest(
                perfomer,
                taskID: taskId,
                gitBranch: gitBranch
            )
        } else if complete {
            try await sendCompleteRequest(perfomer)
        } else if submitTests {
            try await sendSubmitTestResultsRequest(perfomer)
        } else {
            throw NSError(domain: "Either --run, --complete, or --submit-tests flag is required", code: -1)
        }
    }
    
    private func sendRunRequest(
        _ perfomer: IRequestPerformer,
        taskID: String?,
        gitBranch: String?
    ) async throws {
        let result = try await perfomer.perform(
            RunEndpoint(
                taskID: taskID,
                gitBranch: gitBranch
            )
        )
        let cache = MPResultReporterCache(buildID: result.buildId.uuidString)
        try save(cache, to: cacheFilePath)
    }
    
    private func sendCompleteRequest(
        _ perfomer: IRequestPerformer
    ) async throws {
        guard
            let buildStatusString = buildStatus,
            let buildStatusValue = CompleteBuildRequestDTO.BuildStatusDTO(
                rawValue: buildStatusString
            )
        else {
            throw NSError(domain: "--build-status is required for --complete", code: -1)
        }
        
        // Получаем build_id из кеша
        let cache: MPResultReporterCache = try upload(from: cacheFilePath)
        guard
            let buildIDString = cache.buildID,
            let buildID = UUID(uuidString: buildIDString)
        else {
            throw NSError(domain: "Build ID not found in cache or invalid", code: -1)
        }
        
        let result = try await perfomer.perform(
            CompleteEndpoint(
                buildId: buildID,
                buildStatus: buildStatusValue
            )
        )
        
        print("Build completed: \(result.message)")
    }
    
    private func sendSubmitTestResultsRequest(
        _ perfomer: IRequestPerformer
    ) async throws {
        guard let testResultsFilePath = testResultsFile else {
            throw NSError(domain: "--test-results-file is required for --submit-tests", code: -1)
        }
        
        // Получаем build_id из кеша
        let cache: MPResultReporterCache = try upload(from: cacheFilePath)
        guard
            let buildIDString = cache.buildID,
            let buildID = UUID(uuidString: buildIDString)
        else {
            throw NSError(domain: "Build ID not found in cache or invalid", code: -1)
        }
        
        // Загружаем test suite из файла
        let testSuite: TestSuiteDTO = try upload(from: testResultsFilePath)
        
        // Отправляем test suite
        let result = try await perfomer.perform(
            SubmitTestResultsEndpoint(
                buildId: buildID,
                testSuite: testSuite
            )
        )
        
        // Сохраняем отправленный test suite ID в кеш
        var updatedCache = cache
        updatedCache.sentTestSuiteID = result.testSuiteId.uuidString
        try save(updatedCache, to: cacheFilePath)
        
        print("Test suite '\(testSuite.name)' submitted: \(result.message) (test_suite_id: \(result.testSuiteId))")
    }
}

