//
//  Optional+isNil.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation

extension Optional {
    /// Для функционального программирования
    public var isNil: Bool {
        switch self {
        case .none:
            true
        case .some:
            false
        }
    }

    /// Для функционального программирования
    public var isSome: Bool {
        !isNil
    }
}
