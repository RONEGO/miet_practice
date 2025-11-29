//
//  MPDictionary+GetValue.swift
//  MPAPI
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation

private enum LookUpTableGettingError: Error {
    /// Нет такого кода в словаре
    case noSuchCode
    /// Нет такого значения в словаре
    case noSuchValue
}

extension LookUpTable {
    static func getValue(_ code: Int) throws -> _Enum {
        if let value = _Enum.allCases.enumerated().first(where: { $0.offset == code }) {
            return value.element
        }
        throw LookUpTableGettingError.noSuchCode
    }

    static func getCode(_ rawValue: _Enum.RawValue) throws -> UInt8 {
        if let value = _Enum.allCases.enumerated().first(where: { $0.element.rawValue == rawValue }) {
            return UInt8(value.offset)
        }
        throw LookUpTableGettingError.noSuchValue
    }

    static func getCode(_ enumValue: _Enum) throws -> UInt8 {
        try getCode(enumValue.rawValue)
    }
}
