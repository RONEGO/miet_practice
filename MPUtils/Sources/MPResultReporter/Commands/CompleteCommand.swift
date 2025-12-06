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
        abstract: "Завершить сборку"
    )

    @OptionGroup
    var options: MPResultReporterGlobalOptions

    @Option(name: .customLong("build-status"), help: "Статус сборки (обязательно)")
    var buildStatus: String
    
    func run() async throws {
        guard let buildStatusValue = CompleteBuildRequestDTO.BuildStatusDTO(
            rawValue: buildStatus
        ) else {
            throw NSError(domain: "Неверный статус сборки: \(buildStatus)", code: -1)
        }
        
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
        
        let result = try await perfomer.perform(
            CompleteEndpoint(
                buildId: buildID,
                buildStatus: buildStatusValue
            )
        )
        
        print("\(result.message)")
    }
}

