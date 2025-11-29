//
//  TestStatusDTO.swift
//  MPDTO
//
//  Created by Egor Geronin on 24.11.2025.
//

import Foundation
import Vapor

public enum TestStatusDTO: Content {
    /// Неизвестный статус
    case unknown
    /// Успех
    case success
    /// Пропуск
    case skipped
    /// Ошибка
    case failure
}

