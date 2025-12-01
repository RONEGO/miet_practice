//
//  MPResultReporterCache.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

struct MPResultReporterCache: Codable {
    /// ИД билд-а в данный момент
    var buildID: String?
    
    /// ID последнего отправленного test suite
    var sentTestSuiteID: String?
}
