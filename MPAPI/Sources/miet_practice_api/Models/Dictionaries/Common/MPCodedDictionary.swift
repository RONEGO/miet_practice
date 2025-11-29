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
protocol MPCodedDictionaryEnum:
    RawRepresentable,
    CaseIterable,
    Codable,
    Sendable where RawValue: Hashable {
    var code: Int { get }
}

/// Протокол словаря (code: Int)
protocol MPCodedDictionary: Model, Content, Sendable where IDValue == Int {
    associatedtype _DictionaryEnum: MPCodedDictionaryEnum

    /// Инициализатор из кода и значения
    init(id: Int?, value: _DictionaryEnum)
}

extension MPCodedDictionaryEnum {
    var code: Int { rawValue.hashValue }
}
