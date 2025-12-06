//
//  SubmitTestsCommand.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import ArgumentParser
import Foundation
import MPDTO
import MPCore

struct SubmitTestsCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "submit-tests",
        abstract: "Отправить результаты тестов"
    )
    
    @OptionGroup
    var options: MPResultReporterGlobalOptions
    
    @Option(name: .customLong("test-results-file"), help: "Путь к JSON файлу с результатами тестов (обязательно)")
    var testResultsFile: String
    
    func run() async throws {
        guard let url = URL(string: options.baseURL) else {
            throw NSError(domain: "Неверный базовый URL", code: -1)
        }
        let perfomer = RequestPerformer(baseURL: url)
        
        // Получаем build_id из кеша
        let cache: MPResultReporterCache = try upload(from: options.cacheFilePath)
        guard
            let buildIDString = cache.buildID,
            let buildID = UUID(uuidString: buildIDString)
        else {
            throw NSError(domain: "ID сборки не найден в кеше или неверный", code: -1)
        }
        
        // Загружаем test suite из файла
        let testSuite: TestSuiteDTO = try upload(from: testResultsFile)
        
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
        try save(updatedCache, to: options.cacheFilePath)
        
        print("Вязанка тестов (test_suite_id: \(result.testSuiteId)) '\(testSuite.name)' отправлена на сервер: \(result.message)")
    }
}

