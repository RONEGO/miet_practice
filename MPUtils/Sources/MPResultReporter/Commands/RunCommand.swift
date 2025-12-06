//
//  RunCommand.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import ArgumentParser
import Foundation
import MPDTO
import MPCore

struct RunCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "run",
        abstract: "Запустить сборку"
    )
    
    @OptionGroup
    var options: MPResultReporterGlobalOptions
    
    @Option(name: .customLong("task-id"), help: "ID задачи (опционально)")
    var taskId: String?
    
    @Option(name: .customLong("git-branch"), help: "Ветка Git (опционально)")
    var gitBranch: String?
    
    func run() async throws {
        guard let url = URL(string: options.baseURL) else {
            throw NSError(domain: "Неверный базовый URL", code: -1)
        }
        let perfomer = RequestPerformer(baseURL: url)
        
        let result = try await perfomer.perform(
            RunEndpoint(
                taskID: taskId,
                gitBranch: gitBranch
            )
        )
        let cache = MPResultReporterCache(buildID: result.buildId.uuidString)
        try save(cache, to: options.cacheFilePath)
        print("Билд отправлен на сервер: \(result.buildId)")
    }
}

