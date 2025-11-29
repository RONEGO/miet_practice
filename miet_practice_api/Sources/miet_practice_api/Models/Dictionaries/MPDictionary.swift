//
//  DictionaryEnum.swift
//  miet_practice_api
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation
import Fluent
import Vapor

/// Словарь для Enum
protocol MPDictionaryEnum: RawRepresentable, CaseIterable, Codable, Sendable {}

/// Протокол словаря (code: Int)
protocol MPDictionary: Model, Content, Sendable where IDValue == Int {
    associatedtype _DictionaryEnum: MPDictionaryEnum

    /// Инициализатор из кода и значения
    init(code: Int?, value: _DictionaryEnum)

    /// Перегенерация (автозаполнение) таблиц
    static func regenerate(on db: any Database) async throws
}

extension MPDictionary {
    /// Перегенерация (автозаполнение) таблице. Если значения нет – записывается.
    static func regenerate(on db: any Database) async throws {
        for dictionaryValue in _DictionaryEnum.allCases.enumerated() {
            guard try await Self.find(dictionaryValue.offset, on: db) == nil else {
                continue
            }
            let model = Self(
                code: dictionaryValue.offset,
                value: dictionaryValue.element
            )
            try await model.save(on: db)
        }
    }
}
