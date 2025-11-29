//
//  MPDictionary+GetValue.swift
//  MPAPI
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation

private enum MPDictionaryGetValueError: Error {
    case noSuchCode
}

extension MPCodedDictionary {
    func getValue<Value: Decodable>(_ code: String) throws -> Value {
        MPCodedDictionaryEnum
    }
}
