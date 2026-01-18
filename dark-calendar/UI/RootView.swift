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
        HStack {
            Button(action: goToPreviousDay) {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white.opacity(0.8))

            Button("Today", action: goToToday)
                .buttonStyle(.plain)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))

            Button(action: goToNextDay) {
                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white.opacity(0.8))

            Spacer()

            Text(formattedDate)
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()

            // Invisible spacer to balance the left controls
            HStack {
                Image(systemName: "chevron.left").opacity(0)
                Text("Today").opacity(0)
                Image(systemName: "chevron.right").opacity(0)
            }
            .font(.subheadline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
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
