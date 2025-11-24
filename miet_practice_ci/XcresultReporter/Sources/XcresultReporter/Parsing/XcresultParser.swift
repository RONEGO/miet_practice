//
//  XcresultParser.swift
//  XcresultReporter
//
//  Created by Egor Geronin on 24.11.2025.
//

import XCResultKit
import Foundation

public final class XcresultParser: IXcresultParser {
    public func parse(_ resultFile: XCResultFile) throws(XcresultParserError) -> TestSuite {
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

        return TestSuite(
            type: getFramework(testableSummary.testKind),
            cases: testableSummary.tests.map { testsCase in
                let name = testsCase.name ??
                    "UNKNOWN_\(testsCase.identifier ?? UUID().uuidString)"
                let tests = testsCase.subtests.map(getTest(_:))
                let statusCode: TestStatus =
                    if tests.first(where: { $0.statusCode == .failure }) == nil {
                        .success
                    } else {
                        .failure
                    }
                return TestCase(
                    name: name,
                    statusCode: statusCode,
                    duration: testsCase.duration,
                    tests: tests
                )
            }
        )
    }

    private func getTest(_ metadata: ActionTestMetadata) -> Test {
        let name = metadata.name ?? 
            "UNKNOWN_\(metadata.identifier ?? UUID().uuidString)"
        let statusCode: TestStatus =
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
        return Test(
            name: name,
            statusCode: statusCode,
            duration: metadata.duration
        )
    }

    private func getFramework(_ testKind: String?) -> TestFramework {
        switch testKind {
        case "app hosted":
            .xctestUnit
        case "ui":
            .xctestUI
        default:
            .unknown
        }
    }
}
