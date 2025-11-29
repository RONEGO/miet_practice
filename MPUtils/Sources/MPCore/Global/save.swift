//
//  save.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import Foundation

public func save(
    _ encodable: Encodable,
    to path: String,
    fileManager: FileManager = .default
) throws {
    let cacheURL = URL(fileURLWithPath: path)
    let cacheDirectory = cacheURL.deletingLastPathComponent()

    // Создаем директорию, если её нет
    try? fileManager.createDirectory(
        at: cacheDirectory,
        withIntermediateDirectories: true,
        attributes: nil
    )

    // Создаем файл, если его нет
    if !fileManager.fileExists(atPath: path) {
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
    }

    // Записываем result в файл кеша
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let jsonData = try encoder.encode(encodable)
    try jsonData.write(to: cacheURL)
}
