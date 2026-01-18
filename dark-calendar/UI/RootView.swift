//
//  RootView.swift
//  dark-calendar
//
//  Created by Geanpierre Fernandez on 1/18/26.
//

import SwiftUI

struct RootView: View {
    @State private var day = Date()

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            DayTimelineView(
                day: day,
                timeBlocks: MockData.blocks(for: day)
            )
        }
        .background(Color.appBackground)
        #if os(macOS)
        .background(keyboardShortcuts)
        #endif
    }

    #if os(macOS)
    private var keyboardShortcuts: some View {
        Group {
            Button("", action: goToPreviousDay)
                .keyboardShortcut(.leftArrow, modifiers: .command)
            Button("", action: goToNextDay)
                .keyboardShortcut(.rightArrow, modifiers: .command)
            Button("", action: goToToday)
                .keyboardShortcut("t", modifiers: .command)
        }
        .opacity(0)
        .frame(width: 0, height: 0)
    }
    #endif

    private var navigationBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Left: navigation controls
                HStack(spacing: 12) {
                    Button(action: goToPreviousDay) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white.opacity(0.7))
                    .contentShape(Rectangle())

                    Button("Today", action: goToToday)
                        .buttonStyle(.plain)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.7))

                    Button(action: goToNextDay) {
                        Image(systemName: "chevron.right")
                            .font(.body.weight(.semibold))
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white.opacity(0.7))
                    .contentShape(Rectangle())
                }

                Spacer()

                // Center: date label
                Text(formattedDate)
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                // Right: invisible balance for centering
                HStack(spacing: 12) {
                    Image(systemName: "chevron.left")
                        .frame(width: 28, height: 28)
                    Text("Today")
                        .font(.subheadline.weight(.medium))
                    Image(systemName: "chevron.right")
                        .frame(width: 28, height: 28)
                }
                .opacity(0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // Bottom divider
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
        }
        .background(Color.appBackground)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: day)
    }

    private func goToPreviousDay() {
        if let newDay = Calendar.current.date(byAdding: .day, value: -1, to: day) {
            day = newDay
        }
    }

    private func goToNextDay() {
        if let newDay = Calendar.current.date(byAdding: .day, value: 1, to: day) {
            day = newDay
        }
    }

    private func goToToday() {
        day = Date()
    }
}
