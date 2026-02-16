//
//  TrackDistanceView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import CoreLocation

/// UI element displaying current track distance info
struct TrackDistanceView: View {
    private let distance: Double
    private let unit: UnitLength
    init(distance: CLLocationDistance, unit: UnitLength = .kilometers) {
        let converter = DistanceConverter(distance: distance)
        
        self.distance = converter.getDistance(unit)
        self.unit = unit
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(String(format: "%0.2f", distance))
                .font(.largeTitle)
                .monospacedDigit()
                .bold()
                .contentTransition(.numericText())
                .animation(.linear, value: distance)
            Text("Distance \(unit.symbol)")
                .font(.caption)
                .opacity(0.6)
        }
    }
}

#Preview {
    TrackDistanceView(distance: 80)
}
