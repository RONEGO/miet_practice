//
//  MPResultReporter.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import ArgumentParser
import Foundation
import XCResultKit
import MPDTO
import MPCore

@main
struct MPResultReporter: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "MP Репортер результатов",
        subcommands: [
            RunCommand.self,
            CompleteCommand.self,
            SubmitTestsCommand.self,
            SubmitLogCommand.self
        ]
    )
    
    func run() async throws {
        // Если команда не указана, показываем help
        throw CleanExit.helpRequest(self)
    }
}

