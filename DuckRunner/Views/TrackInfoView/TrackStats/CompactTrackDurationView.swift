//
//  CompactTrackDurationView.swift
//  DuckRunner
//
//  Created by vladukha on 17.02.2026.
//

import SwiftUI

struct CompactTrackDurationView: View {
    let startDate: Date
    let stopDate: Date
    var body: some View {
        duration
    }
    
    private var duration: some View {
        HStack(spacing: 2) {
            let interval = stopDate.timeIntervalSince(startDate)
            Image(systemName: "timer")
                .bold()
            Text(TimeIntervalFormatter.string(from: interval) ?? "_")
                .lineLimit(1)
            
        }
        .font(.caption)
        .opacity(0.6)
    }
}

#Preview {
    CompactTrackDurationView(startDate: .now, stopDate: .now.add(.hour, value: 1))
}
