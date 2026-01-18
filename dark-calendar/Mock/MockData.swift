//
//  MockData.swift
//  dark-calendar
//
//  Created by Geanpierre Fernandez on 1/18/26.
//

import Foundation

enum MockData {
    static func blocks(for day: Date) -> [TimeBlock] {
        let cal = Calendar.current
        func at(_ h: Int, _ m: Int = 0) -> Date {
            cal.date(bySettingHour: h, minute: m, second: 0, of: day)!
        }

        return [
            .init(title: "Deep Work", start: at(9), end: at(10, 30), colorHex: "#5865F2"),
            .init(title: "Lecture",   start: at(11), end: at(12, 15), colorHex: "#57F287"),
            .init(title: "Gym",       start: at(17, 30), end: at(18, 30), colorHex: "#FEE75C"),
        ]
    }
}
