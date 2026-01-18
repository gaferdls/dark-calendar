//
//  TimeBlock.swift
//  dark-calendar
//
//  Created by Geanpierre Fernandez on 1/18/26.
//

import Foundation

struct TimeBlock: Identifiable, Hashable {
    let id: UUID
    let title: String
    let start: Date
    let end: Date
    let colorHex: String

    init(id: UUID = UUID(), title: String, start: Date, end: Date, colorHex: String) {
        precondition(end > start, "end must be after start")
        self.id = id
        self.title = title
        self.start = start
        self.end = end
        self.colorHex = colorHex
    }

    var duration: TimeInterval { end.timeIntervalSince(start) }
}
