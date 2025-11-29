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
protocol LookUpTableEnum:
    RawRepresentable,
    CaseIterable,
    Codable,
    Sendable where RawValue: Equatable {}

/// Протокол словаря (code: Int)
protocol LookUpTable: Model, Content, Sendable where IDValue == UInt8 {
    associatedtype _Enum: LookUpTableEnum

    /// Значение в таблице
    var value: _Enum { get }

    /// Инициализатор из кода и значения
    init(id code: UInt8?, value: _Enum)
}
