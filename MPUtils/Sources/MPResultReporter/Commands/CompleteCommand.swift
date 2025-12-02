//
//  CompleteCommand.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import ArgumentParser
import Foundation
import MPDTO
import MPCore

struct CompleteCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "complete",
        abstract: "Complete build"
    )

    @OptionGroup
    var options: MPResultReporterGlobalOptions

    @Option(name: .customLong("build-status"), help: "Build status (required)")
    var buildStatus: String
    
    func run() async throws {
        guard let buildStatusValue = CompleteBuildRequestDTO.BuildStatusDTO(
            rawValue: buildStatus
        ) else {
            throw NSError(domain: "Invalid build status: \(buildStatus)", code: -1)
        }
        
        guard let url = URL(string: options.baseURL) else {
            throw NSError(domain: "Invalid base URL", code: -1)
        }
        let perfomer = RequestPerformer(baseURL: url)
        
        // Получаем build_id из кеша
        let cache: MPResultReporterCache = try upload(from: options.cacheFilePath)
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
}

