//
//  MeasuredTrackCellView.swift
//  DuckRunner
//
//  Created by vladukha on 05.03.2026.
//
import SwiftUI

private struct MeasuredTrackCellView: View {
    let measured: MeasuredTrack

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                type
                Spacer()
                duration
            }
            
            
            date
            
        }
    }
    
    private var type: some View {
        HStack(spacing: 4) {
            Image(systemName: measured.measurement.image)
                .foregroundStyle(Color.accentColor)
            Text(measured.measurement.name)
                .font(.headline)
        }
    }
    
    private var date: some View {
        HStack {
            let startDate = measured.startDate
            Text(startDate, style: .date)
            
            Text(startDate, style: .time)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private var duration: some View {
        if let stop = measured.track.stopDate {
            let duration = stop.timeIntervalSince(measured.track.startDate)
            HStack(spacing: 4) {
                Text(TimeIntervalFormatter.string(from: duration) ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Image(systemName: "timer")
                    .foregroundStyle(Color.green.mix(with: .white, by: 0.2))
            }
            
        }
    }
}
