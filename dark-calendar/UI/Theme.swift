//
//  Theme.swift
//  dark-calendar
//
//  Created by Geanpierre Fernandez on 1/18/26.
//

import SwiftUI

extension Color {
    static let appBackground = Color(red: 0.07, green: 0.07, blue: 0.08)

    init?(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6, let v = Int(s, radix: 16) else { return nil }

        let r = Double((v >> 16) & 0xFF) / 255
        let g = Double((v >> 8) & 0xFF) / 255
        let b = Double(v & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
