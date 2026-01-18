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
            let blockWidth = contentWidth * 0.78 // ~78% of available content area

            ForEach(timeBlocks) { block in
                TimeBlockView(timeBlock: block)
                    .frame(width: blockWidth, height: blockHeight(for: block))
                    .offset(x: gutterWidth + 4, y: yOffset(for: block))
            }
        }
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
