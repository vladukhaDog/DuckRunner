//
//  CompactTrackDistanceView.swift
//  DuckRunner
//
//  Created by vladukha on 17.02.2026.
//

import SwiftUI
import CoreLocation

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
