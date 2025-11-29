//
//  String+UUID.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation

extension Optional<String> {
    public func toUUID() -> UUID? {
        if let self {
            UUID(uuidString: self)
        } else {
            nil
        }
    }
}
