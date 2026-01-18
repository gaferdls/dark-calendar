//
//  TimeBlockView.swift
//  dark-calendar
//

import SwiftUI

struct TimeBlockView: View {
    let timeBlock: TimeBlock

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(blockColor)
            .overlay(alignment: .topLeading) {
                Text(timeBlock.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(6)
            }
    }

    private var blockColor: Color {
        Color(hex: timeBlock.colorHex) ?? .blue
    }
}
