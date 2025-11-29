//
//  UIColor+hex.swift
//  MPTestableApp
//
//  Created by Egor Geronin on 23.11.2025.
//

import UIKit

extension UIColor {
    /// Преобразование UIColor из hex строки
    convenience init(hex: String) {
        // Убираем # и пробелы
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        // Делаем короткие форматы (например FFF) → (FFFFFF)
        if hexString.count == 3 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        } else if hexString.count == 4 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let r, g, b, a: CGFloat

        switch hexString.count {
        case 6: // RRGGBB
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255
            b = CGFloat(rgbValue & 0x0000FF) / 255
            a = 1.0
        case 8: // RRGGBBAA
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255
            a = CGFloat(rgbValue & 0x000000FF) / 255
        default:
            // Некорректный формат → возвращаем серый
            r = 0.5; g = 0.5; b = 0.5; a = 1.0
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
