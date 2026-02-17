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
    
    let unit: UnitSpeed
    init(track: Track, unit: UnitSpeed) {
        self.track = track
        self.unit = unit
        
        
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
                CompactTrackDistanceView(distance: track.points.totalDistance(),
                                         unit: unit)
                Spacer()
                if let stopDate = track.stopDate {
                    CompactTrackDurationView(startDate: track.startDate,
                                             stopDate: stopDate)
                }
                Spacer()
                if let speed = track.points.topSpeed() {
                    CompactTrackTopSpeedView(speed: speed,
                                             unit: unit)
                }
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
