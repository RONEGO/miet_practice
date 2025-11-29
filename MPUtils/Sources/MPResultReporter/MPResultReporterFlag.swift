//
//  FlagStart.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import ArgumentParser

enum MPResultReporterFlag: String, ExpressibleByArgument, CaseIterable {
    /// Флаг на отправку /v1/builds/run
    case run = "run"
    /// Флаг на отправку /v1/builds/complete
    case complete = "complete"
}
