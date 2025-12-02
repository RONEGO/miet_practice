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
        abstract: "Run build"
    )
    
    @OptionGroup
    var options: MPResultReporterGlobalOptions
    
    @Option(name: .customLong("task-id"), help: "Task ID (optional)")
    var taskId: String?
    
    @Option(name: .customLong("git-branch"), help: "Git branch (optional)")
    var gitBranch: String?
    
    func run() async throws {
        guard let url = URL(string: options.baseURL) else {
            throw NSError(domain: "Invalid base URL", code: -1)
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
    }
}

