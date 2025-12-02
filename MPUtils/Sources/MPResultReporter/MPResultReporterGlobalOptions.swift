//
//  MPResultReporterGlobalOptions.swift
//  MPUtils
//
//  Created by Egor Geronin on 02.12.2025.
//

import ArgumentParser

struct MPResultReporterGlobalOptions: ParsableArguments {
    @Argument(help: "Base url for endpoints")
    var baseURL: String

    @Argument(help: "The path to a cache file where cache will be stored")
    var cacheFilePath: String
}
