// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import XCResultKit

@main
struct XcresultReporter: ParsableCommand {
    @Argument(help: "The path to an `.xcresult` bundle")
    var pathBundle: String

    private var parser: IXcresultParser {
        XcresultParser()
    }

    func run() throws {
        guard let url = URL(string: pathBundle) else { return }
        let resultFile = XCResultFile(url: url)

        let result = try parser.parse(resultFile)

        print("parser")
        print("SUITE: \(result.type)")
        result.cases.forEach { testCase in
            print(
                "\tCASE: \(testCase.name) | dur \(testCase.duration) | \(testCase.statusCode)"
            )
            testCase.tests.forEach { test in
                print(
                    "\t\tTEST: \(test.name) | dur \(test.duration ?? -1) | \(test.statusCode)"
                )
            }
        }
    }
}
