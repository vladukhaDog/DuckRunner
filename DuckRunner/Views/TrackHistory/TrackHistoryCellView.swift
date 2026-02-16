//
//  TrackHistoryCellView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI

/// View Cell of a Track in history list
struct TrackHistoryCellView: View {
    let track: Track
    let distanceAmount: Double
    let speedAmount: Int
    let unit: UnitSpeed
    init(track: Track, unit: UnitSpeed) {
        self.track = track
        self.unit = unit
        let converter = DistanceConverter(distance: track.points.totalDistance())
        self.distanceAmount = converter.getDistance(unit.unitLength)
        
        let speed = track.points.topSpeed() ?? 0
        let speedConverter = SpeedConverter(speed: speed)
        self.speedAmount = speedConverter.getSpeed(unit)
        
    }
    var body: some View {
        VStack() {
            HStack {
                date
                Spacer()
                Image(systemName: "chevron.right")
            }
            time
                .frame(maxWidth: .infinity, alignment: .leading)
            TrackMapSnippet(track: track)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                .opacity(0.8)
                .disabled(true)
                .allowsHitTesting(false)
            HStack {
                distance
                Spacer()
                duration
                Spacer()
                topSpeed
            }
            
        }
        .foregroundStyle(Color.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassEffect(in: RoundedRectangle(cornerRadius: 15))
        .padding()
    }
    
    private var time: some View {
        Text(track.startDate.toString(format: "EEE HH:mm"))
            .font(.caption)
            .fontWeight(.semibold)
            .opacity(0.7)
    }
    
    private var topSpeed: some View {
        HStack(spacing: 2) {
            Image(systemName: "gauge.open.with.lines.needle.84percent.exclamation")
            Text(speedAmount.description)
                .bold()
            Text(unit.symbol)
        }
        .font(.caption)
        .opacity(0.6)
    }
    
    private var distance: some View {
        HStack(spacing: 2) {
            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
            Text(String(format: "%0.2f", distanceAmount))
                .bold()
            Text(unit.unitLength.symbol)
        }
        .font(.caption)
        .opacity(0.6)
    }
    
    @ViewBuilder
    private var duration: some View {
        if let stopDate = track.stopDate {
            let interval = stopDate.timeIntervalSince(track.startDate)
            HStack(spacing: 2) {
                Image(systemName: "timer")
                    .bold()
                Text(TimeIntervalFormatter.string(from: interval) ?? "_")
                    .lineLimit(1)
                
            }
            .font(.caption)
            .opacity(0.6)
        }
    }
    
    private var date: some View {
        let date = track.startDate.toString(style: .medium)
        return Text(date)
            .font(.title2)
            .bold()
    }
}

#Preview {
    ZStack {
//        Color.cyan.opacity(0.3)
        VStack {
            TrackHistoryCellView(track: .filledTrack, unit: .kilometersPerHour)
            TrackHistoryCellView(track: .filledTrack, unit: .milesPerHour)
        }
    }
}
