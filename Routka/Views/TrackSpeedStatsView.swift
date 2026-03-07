//
//  TrackSpeedStatsView.swift
//  Routka
//
//  Created by vladukha on 28.02.2026.
//

import SwiftUI
import Charts
import FlowLayout

struct TrackSpeedStatsView: View {
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    let track: Track
    let parentTrack: Track?
    var body: some View {
        VStack {
            Chart {
                if let parentTrack {
                    ForEach(parentTrack.points.enumerated(), id: \.element.hashValue) { index, point in
                        LineMark(
                            x: .value("Time Elapsed (s)", point.date.timeIntervalSince(parentTrack.startDate)),
                            y: .value("Speed", SpeedConverter(speed: point.speed).getSpeed(.byName(speedUnit))),
                            series: .value("", "Parent")
                        )
                        .foregroundStyle(Color.gray)
                        .lineStyle(.init(lineWidth: 3, lineCap: .round, dash: [4,6]))
                        .interpolationMethod(.cardinal)
                    }
                }
                ForEach(track.points.enumerated(), id: \.element.hashValue) { index, point in
                    LineMark(
                        x: .value("Time Elapsed (s)", point.date.timeIntervalSince(track.startDate)),
                        y: .value("Speed", SpeedConverter(speed: point.speed).getSpeed(.byName(speedUnit))),
                        series: .value("", "Current")
                    )
                    .foregroundStyle(Color.cyan.opacity(0.5))
                    .lineStyle(.init(lineWidth: 6, lineCap: .round))
                    .interpolationMethod(.cardinal)
                }
                if let topSpeedPoint = track.points.topSpeedPoint() {
                    PointMark(
                        x: .value("Time Elapsed (s)", topSpeedPoint.date.timeIntervalSince(track.startDate)),
                        y: .value("Speed", SpeedConverter(speed: topSpeedPoint.speed).getSpeed(.byName(speedUnit)))
                    )
                    .annotation(position: .top, alignment: .center) {
                        Text("🔥")
                            .font(.title2)
                            .accessibilityLabel("Top Speed")
                    }
                }
                
            }
            .chartYAxisLabel(speedUnit)
            .chartXAxisLabel("Time Elapsed (s)")
            FlowStack(HSpacing: 20) {
                currentTrackLegend
                parentTrackLegend
            }
            
        }
    }
    
    @ViewBuilder
    private var parentTrackLegend: some View {
        if parentTrack != nil {
            HStack(spacing: 8) {
                StraightLine()
                    .stroke(Color.gray, style: .init(lineWidth: 4,
                                                     lineCap: .round,
                                                     dash: [4,6]))
                    .frame(width: 30, height: 4)
                Text("Original route")
                    .font(.caption)
            }
        }
    }
    
    private var currentTrackLegend: some View {
        HStack(spacing: 8) {
            StraightLine()
                .stroke(Color.cyan, style: .init(lineWidth: 4, lineCap: .round))
                .frame(width: 30, height: 4)
            Text("This track")
                .font(.caption)
        }
    }
}

#Preview {
    TrackSpeedStatsView(track: .filledTrack, parentTrack: .filledTrack)
        .padding()
}
