//
//  DayTimelineView.swift
//  dark-calendar
//

import SwiftUI

struct DayTimelineView: View {
    let day: Date
    let timeBlocks: [TimeBlock]

    private let hourHeight: CGFloat = 60
    private let gutterWidth: CGFloat = 50
    private let totalHours = 24

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ZStack(alignment: .topLeading) {
                gridLines
                timeGutter
                blocksLayer
                if isToday {
                    nowIndicator
                }
            }
            .frame(height: CGFloat(totalHours) * hourHeight)
        }
        .background(Color.appBackground)
    }

    private var gridLines: some View {
        VStack(spacing: 0) {
            ForEach(0..<totalHours, id: \.self) { _ in
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, gutterWidth)
                Spacer()
                    .frame(height: hourHeight - 1)
            }
        }
    }

    private var timeGutter: some View {
        VStack(spacing: 0) {
            ForEach(0..<totalHours, id: \.self) { hour in
                Text(hourLabel(for: hour))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: gutterWidth, height: hourHeight, alignment: .topTrailing)
                    .padding(.trailing, 8)
                    .offset(y: -6)
            }
        }
    }

    private var blocksLayer: some View {
        GeometryReader { geo in
            let contentWidth = geo.size.width - gutterWidth - 16 // 16 = leading(4) + trailing(12) spacing
            let baseWidth = contentWidth * 0.78 // ~78% of available content area
            let layouts = computeBlockLayouts()

            ForEach(timeBlocks) { block in
                let layout = layouts[block.id] ?? BlockLayout(columnIndex: 0, columnCount: 1)
                let columnWidth = baseWidth / CGFloat(layout.columnCount)
                let xOffset = gutterWidth + 4 + CGFloat(layout.columnIndex) * columnWidth

                TimeBlockView(timeBlock: block)
                    .frame(width: columnWidth, height: blockHeight(for: block))
                    .offset(x: xOffset, y: yOffset(for: block))
            }
        }
    }

    private struct BlockLayout {
        let columnIndex: Int
        let columnCount: Int
    }

    private func computeBlockLayouts() -> [UUID: BlockLayout] {
        guard !timeBlocks.isEmpty else { return [:] }

        // Sort blocks deterministically: start asc, end asc, id asc
        let sorted = timeBlocks.sorted { a, b in
            if a.start != b.start { return a.start < b.start }
            if a.end != b.end { return a.end < b.end }
            return a.id.uuidString < b.id.uuidString
        }

        // Two blocks overlap iff a.start < b.end AND b.start < a.end (strict inequality)
        func overlaps(_ a: TimeBlock, _ b: TimeBlock) -> Bool {
            a.start < b.end && b.start < a.end
        }

        // Union-Find for grouping chain overlaps
        var parent = [UUID: UUID]()
        for block in sorted { parent[block.id] = block.id }

        func find(_ id: UUID) -> UUID {
            if parent[id] != id { parent[id] = find(parent[id]!) }
            return parent[id]!
        }

        func union(_ a: UUID, _ b: UUID) {
            let rootA = find(a), rootB = find(b)
            if rootA != rootB { parent[rootA] = rootB }
        }

        // Union all overlapping pairs
        for i in 0..<sorted.count {
            for j in (i + 1)..<sorted.count {
                if overlaps(sorted[i], sorted[j]) {
                    union(sorted[i].id, sorted[j].id)
                }
            }
        }

        // Group blocks by their root
        var groups = [UUID: [TimeBlock]]()
        for block in sorted {
            groups[find(block.id), default: []].append(block)
        }

        // Assign columns within each group
        var layouts = [UUID: BlockLayout]()

        for (_, group) in groups {
            if group.count == 1 {
                layouts[group[0].id] = BlockLayout(columnIndex: 0, columnCount: 1)
                continue
            }

            // Sort group deterministically
            let sortedGroup = group.sorted { a, b in
                if a.start != b.start { return a.start < b.start }
                if a.end != b.end { return a.end < b.end }
                return a.id.uuidString < b.id.uuidString
            }

            // Greedy column assignment: track end time of last block in each column
            var columnEndTimes = [Date]()
            var blockColumns = [UUID: Int]()

            for block in sortedGroup {
                var assigned: Int? = nil
                for (col, endTime) in columnEndTimes.enumerated() {
                    if block.start >= endTime { // touching (==) is allowed, not overlapping
                        assigned = col
                        columnEndTimes[col] = block.end
                        break
                    }
                }
                if assigned == nil {
                    assigned = columnEndTimes.count
                    columnEndTimes.append(block.end)
                }
                blockColumns[block.id] = assigned
            }

            let columnCount = columnEndTimes.count
            for block in sortedGroup {
                layouts[block.id] = BlockLayout(columnIndex: blockColumns[block.id]!, columnCount: columnCount)
            }
        }

        return layouts
    }

    private var isToday: Bool {
        Calendar.current.isDate(day, inSameDayAs: Date())
    }

    private var nowYOffset: CGFloat {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: day)
        let secondsFromMidnight = Date().timeIntervalSince(dayStart)
        let hoursFromMidnight = secondsFromMidnight / 3600
        return CGFloat(hoursFromMidnight) * hourHeight
    }

    private var nowIndicator: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color.red.opacity(0.85))
                .frame(width: 8, height: 8)
            Rectangle()
                .fill(Color.red.opacity(0.6))
                .frame(height: 1)
        }
        .offset(x: gutterWidth - 4, y: nowYOffset - 4) // -4 to vertically center the 8pt circle on the line
    }

    private func hourLabel(for hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        var components = Calendar.current.dateComponents([.year, .month, .day], from: day)
        components.hour = hour
        guard let date = Calendar.current.date(from: components) else { return "" }
        return formatter.string(from: date)
    }

    private func yOffset(for block: TimeBlock) -> CGFloat {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: day)
        let secondsFromMidnight = block.start.timeIntervalSince(dayStart)
        let hoursFromMidnight = secondsFromMidnight / 3600
        return CGFloat(hoursFromMidnight) * hourHeight
    }

    private func blockHeight(for block: TimeBlock) -> CGFloat {
        let durationHours = block.duration / 3600
        return max(CGFloat(durationHours) * hourHeight, 20)
    }
}
