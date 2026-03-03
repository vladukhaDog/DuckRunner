//
//  TrackSpeedStatsView.swift
//  DuckRunner
//
//  Created by vladukha on 28.02.2026.
//

import SwiftUI
import Charts

struct TrackSpeedStatsView: View {
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    let track: Track
    let parentTrack: Track?
    var body: some View {
        Chart {
            ForEach(track.points.enumerated(), id: \.element.hashValue) { index, point in
                LineMark(
                    x: .value("Time Elapsed (s)", point.date.timeIntervalSince(track.startDate)),
                    y: .value("Speed", SpeedConverter(speed: point.speed).getSpeed(.byName(speedUnit))),
                    series: .value("", "Current")
                )
                .foregroundStyle(Color.cyan.opacity(0.7))
                .lineStyle(.init(lineWidth: 6, lineCap: .round))
                .interpolationMethod(.cardinal)
            }
            if let parentTrack {
                ForEach(parentTrack.points.enumerated(), id: \.element.hashValue) { index, point in
                    LineMark(
                        x: .value("Time Elapsed (s)", point.date.timeIntervalSince(parentTrack.startDate)),
                        y: .value("Speed", SpeedConverter(speed: point.speed).getSpeed(.byName(speedUnit))),
                        series: .value("", "Parent")
                    )
                    .foregroundStyle(Color.gray)
                    .lineStyle(.init(lineWidth: 6, lineCap: .round))
                    .interpolationMethod(.cardinal)
                }
            }
        }
        .chartYAxisLabel(speedUnit)
        .chartXAxisLabel("Time Elapsed (s)")
    }
}

#Preview {
    TrackSpeedStatsView(track: .filledTrack, parentTrack: .filledTrack)
}
