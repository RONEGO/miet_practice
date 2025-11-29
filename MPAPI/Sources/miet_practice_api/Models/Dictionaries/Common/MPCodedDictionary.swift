//
//  DictionaryEnum.swift
//  MPAPI
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation
import Fluent
import Vapor

/// Словарь для Enum
protocol MPDictionaryEnum: RawRepresentable, CaseIterable, Codable, Sendable {}

/// Протокол словаря (code: Int)
protocol MPCodedDictionary: Model, Content, Sendable where IDValue == Int {
    associatedtype _DictionaryEnum: MPDictionaryEnum

    /// Инициализатор из кода и значения
    init(id: Int?, value: _DictionaryEnum)
}
