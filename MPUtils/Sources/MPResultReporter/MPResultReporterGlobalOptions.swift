//
//  MPResultReporterGlobalOptions.swift
//  MPUtils
//
//  Created by Egor Geronin on 02.12.2025.
//

import ArgumentParser

struct MPResultReporterGlobalOptions: ParsableArguments {
    @Argument(help: "Базовый URL для эндпоинтов")
    var baseURL: String

    @Argument(help: "Путь к файлу кеша, где будет храниться кеш")
    var cacheFilePath: String
}
