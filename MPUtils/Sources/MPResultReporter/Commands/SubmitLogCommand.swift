//
//  SubmitLogCommand.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import ArgumentParser
import Foundation
import MPDTO
import MPCore

struct SubmitLogCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "submit-log",
        abstract: "Отправить файл лога"
    )
    
    @OptionGroup
    var options: MPResultReporterGlobalOptions
    
    @Option(name: .customLong("test-suite-log"), help: "Путь к логу набора тестов (обязательно)")
    var testSuiteLog: String
    
    func run() async throws {
        guard let url = URL(string: options.baseURL) else {
            throw NSError(domain: "Неверный базовый URL", code: -1)
        }
        let perfomer = RequestPerformer(baseURL: url)
        
        // Получаем данные из кеша
        let cache: MPResultReporterCache = try upload(from: options.cacheFilePath)
        guard
            let testSuiteResultIDString = cache.sentTestSuiteID,
            let testSuiteResultID = UUID(uuidString: testSuiteResultIDString)
        else {
            throw NSError(domain: "ID результата набора тестов не найден в кеше или неверный", code: -1)
        }
        
        // Проверяем существование файла
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: testSuiteLog) else {
            throw NSError(domain: "Файл лога не найден по пути: \(testSuiteLog)", code: -1)
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: testSuiteLog))

        // Отправляем файл
        let result = try await perfomer.perform(
            UploadLogEndpoint(
                testSuiteResultId: testSuiteResultID,
                data: String(data: data, encoding: .utf8) ?? "EMPTY",
                fileName: "\(testSuiteResultID).log"
            )
        )
        
        print("Файл с логами сборки (artefact_id: \(result.artefactId)) отправлен на сервер: \(result.message)")
    }
}

