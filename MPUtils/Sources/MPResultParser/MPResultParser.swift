// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import XCResultKit
import MPDTO
import MPCore

@main
struct MPResultParser: ParsableCommand {

    @Argument(help: "The path to an `.xcresult` bundle")
    var xcresultPath: String
    
    @Argument(help: "The path to a cache file where the parsed result will be stored")
    var cacheFilePath: String

    private var parser: IResultParser { ResultParser() }

    func run() throws {
        let url = URL(fileURLWithPath: xcresultPath)
        let resultFile = XCResultFile(url: url)
        let result = try parser.parse(resultFile)

        try save(result, to: cacheFilePath)
    }
}
