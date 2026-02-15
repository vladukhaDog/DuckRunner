//
//  TrackTimeView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI

struct TrackTimeView: View {
    
    let startDate: Date
    let stopDate: Date?
    private let testInterval: TimeInterval?
    
    init(startDate: Date, stopDate: Date?) {
        self.startDate = startDate
        self.stopDate = stopDate
        self.testInterval = nil
    }
    
    fileprivate init(testInterval: TimeInterval) {
        self.testInterval = testInterval
        self.startDate = .now
        self.stopDate = .distantFuture
    }
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated // e.g., "1 minute, 10 seconds"
        // Or use .positional for "1:10" (minutes:seconds) or "1:11:10" (hours:minutes:seconds)
//         formatter.unitsSty/le = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }()
    
    var body: some View {
        TimelineView(.periodic(from: startDate, by: 1)) { context in
            let interval: TimeInterval = testInterval ??
            (stopDate ?? context.date)
                .timeIntervalSince(startDate)
            VStack(spacing: 0) {
                Text(formatter.string(from: interval) ?? "_")
                    .font(.largeTitle)
                    .lineLimit(1)
                    .monospacedDigit()
                    .bold()
                    .minimumScaleFactor(0.7)
                Text("Time")
                    .font(.caption)
                    .opacity(0.6)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var date = Date()
    let stride = stride(from: 8000, to: 8100, by: 5)
    VStack {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(Array(stride), id: \.self) { i in
                    TrackTimeView(testInterval: TimeInterval(i))
                        .padding()
                }
            }
        TrackTimeView(startDate: date, stopDate: Date())
            .padding()
        Button("RESET") {
            date = Date()
        }
    }
}
