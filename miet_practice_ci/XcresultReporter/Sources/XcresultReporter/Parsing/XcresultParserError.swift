//
//  XcresultParserError.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation

public enum XcresultParserError: LocalizedError {
    case noneInvocationRecord
    case oneTestTypePerFile

    public var errorDescription: String? {
        switch self {
        case .noneInvocationRecord:
            "Couldn't extract any test invocation records. File is in the correct format."
        case .oneTestTypePerFile:
            "Xcresult file contains more than one test type per file. Please, run the test again."
        }
    }
}
