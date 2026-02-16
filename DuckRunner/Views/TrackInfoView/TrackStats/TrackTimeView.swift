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
    
   
    
    var body: some View {
        TimelineView(.periodic(from: startDate, by: 1)) { context in
            let interval: TimeInterval = testInterval ??
            (stopDate ?? context.date)
                .timeIntervalSince(startDate)
            VStack(spacing: 0) {
                Text(TimeIntervalFormatter.string(from: interval) ?? "_")
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
