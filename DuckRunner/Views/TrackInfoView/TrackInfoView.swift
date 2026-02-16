//
//  TrackInfoView.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import Combine
internal import _LocationEssentials

struct TrackInfoView: View {
    let track: Track
    private let unitSpeed: UnitSpeed
    init(track: Track, unit: UnitSpeed) {
        self.track = track
        self.unitSpeed = unit
    }
    
    var body: some View {
        EqualFillHStack {
            TrackTimeView(startDate: track.startDate,
                          stopDate: track.stopDate)
            let speed = track.points.topSpeed() ?? 0
            TrackTopSpeedView(speed,
                              displayUnit: unitSpeed)
            let distance = track.points.totalDistance()
            TrackDistanceView(distance: distance,
                              unit: unitSpeed.unitLength)
        }
        
        .padding()
        .frame(maxWidth: .infinity)
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
        .animation(.bouncy, value: track.stopDate == nil)
    }
    
}

#Preview {
    ZStack {
        Color.cyan.opacity(0.4)
//        BaseMapView(trackService: TrackService(), locationService: LocationService())
        TrackInfoView(track: .filledTrack, unit: .kilometersPerHour)
    }
}
