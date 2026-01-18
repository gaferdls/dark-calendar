//
//  ContentView.swift
//  dark-calendar
//
//  Created by Geanpierre Fernandez on 1/18/26.
//

import SwiftUI

struct RootView: View {
    @State private var day = Date()

    var body: some View {
        DayTimelineView(
            day : day,
            timeBlocks:  MockData.blocks(for: day)
        )
        .background(Color.appBackground)
    }
}
