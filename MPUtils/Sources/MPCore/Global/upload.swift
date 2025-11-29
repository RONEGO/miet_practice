//
//  upload.swift
//  MPUtils
//
//  Created by Egor Geronin on 30.11.2025.
//

import Foundation

public func upload<Value: Decodable>(
    from path: String,
    fileManager: FileManager = .default
) throws -> Value {
    let fileURL = URL(fileURLWithPath: path)

    // Проверяем существование файла
    guard fileManager.fileExists(atPath: path) else {
        throw NSError(
            domain: "FileNotFound",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "File not found at path: \(path)"]
        )
    }

    // Читаем данные из файла
    let data = try Data(contentsOf: fileURL)

    // Декодируем JSON в указанный тип
    let decoder = JSONDecoder()
    let value = try decoder.decode(Value.self, from: data)

    return value
}
