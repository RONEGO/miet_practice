//
//  MPDictionary+GetValue.swift
//  MPAPI
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation

private enum MPDictionaryGetValueError: Error {
    /// Нет такого кода в словаре
    case noSuchCode
    /// Нет такого значения в словаре
    case noSuchValue
}

extension MPCodedDictionary {
    func getValue(_ code: Int) throws -> _DictionaryEnum {
        if let value = _DictionaryEnum.allCases.first(where: { $0.code == code }) {
            return value
        }
        throw MPDictionaryGetValueError.noSuchCode
    }

    func getCode(_ value: _DictionaryEnum.RawValue) throws -> Int {
        if let value = _DictionaryEnum.allCases.first(where: { $0.rawValue == value }) {
            return value.code
        }
        throw MPDictionaryGetValueError.noSuchValue
    }
}
