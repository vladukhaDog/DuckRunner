//
//  CompactTrackDistanceView.swift
//  DuckRunner
//
//  Created by vladukha on 17.02.2026.
//

import SwiftUI
import CoreLocation

/**
 A view that displays the distance of a track in a compact format.

 - Parameters:
   - distance: The current distance value to be displayed, converted from CLLocationDistance.
   - unit: The unit of speed measurement (e.g., kilometers per hour or miles per hour).
 */
struct CompactTrackDistanceView: View {
    let distanceAmount: Double
    let unit: UnitSpeed
    
    init(distance: CLLocationDistance, unit: UnitSpeed) {
        self.distanceAmount = DistanceConverter(distance: distance)
            .getDistance(unit.unitLength)
        self.unit = unit
    }
    
    var body: some View {
        distance
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
}

#Preview {
    CompactTrackDistanceView(distance: 80.33, unit: .kilometersPerHour)
}

