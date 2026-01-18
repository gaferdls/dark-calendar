//
//  TimeBlockView.swift
//  dark-calendar
//

import SwiftUI

struct TimeBlockView: View {
    let timeBlock: TimeBlock

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(blockColor)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                Text(timeBlock.title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.95))
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
            }
    }

    private var blockColor: Color {
        Color(hex: timeBlock.colorHex) ?? .blue
    }
}
