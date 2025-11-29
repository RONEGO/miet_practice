//
//  ResultParser.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import XCResultKit
import Foundation
import MPDTO

public final class ResultParser: IResultParser {
    public func parse(_ resultFile: XCResultFile) throws(ResultParserError) -> TestSuiteDTO {
        guard let invocationRecord = resultFile.getInvocationRecord() else {
            throw .noneInvocationRecord
        }

        let testableSummaries: [ActionTestableSummary] = invocationRecord
            .actions
            .compactMap { action -> ActionTestPlanRunSummaries? in
                guard
                    let id = action.actionResult.testsRef?.id,
                    let summaries = resultFile.getTestPlanRunSummaries(id: id)
                else {
                    return nil
                }
                return summaries
            }
            .flatMap(\.summaries)
            .flatMap(\.testableSummaries)


        guard
            testableSummaries.count == 1,
            let testableSummary = testableSummaries.first
        else {
            throw .oneTestTypePerFile
        }

        return TestSuiteDTO(
            type: getFramework(testableSummary.testKind),
            cases: testableSummary.tests.map { testsCase in
                let name = testsCase.name ??
                    "UNKNOWN_\(testsCase.identifier ?? UUID().uuidString)"
                let tests = testsCase.subtests.map(getTest(_:))
                let statusCode: TestStatusDTO =
                    if tests.first(where: { $0.statusCode == .failure }) == nil {
                        .success
                    } else {
                        .failure
                    }
                return TestCaseDTO(
                    name: name,
                    statusCode: statusCode,
                    duration: testsCase.duration,
                    tests: tests
                )
            }
        )
    }

    private func getTest(_ metadata: ActionTestMetadata) -> TestDTO {
        let name = metadata.name ??
            "UNKNOWN_\(metadata.identifier ?? UUID().uuidString)"
        let statusCode: TestStatusDTO =
            switch metadata.testStatus {
            case "Success":
                .success
            case "Failure":
                .failure
            case "Skipped":
                .skipped
            default:
                .unknown
            }
        return TestDTO(
            name: name,
            statusCode: statusCode,
            duration: metadata.duration
        )
    }

    private func getFramework(_ testKind: String?) -> TestFrameworkDTO {
        switch testKind {
        case "app hosted":
            .xctestUnit
        case "UI":
            .xctestUI
        default:
            .unknown
        }
    }
}
