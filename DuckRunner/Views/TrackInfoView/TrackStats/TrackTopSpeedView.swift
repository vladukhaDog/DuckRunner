//
//  TrackTopSpeedView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import CoreLocation

/// UI element which shows current Top speed
struct TrackTopSpeedView: View {
    private let speedConverter: SpeedConverter
    private let displayUnit: UnitSpeed
    
    init(_ speed: CLLocationSpeed, displayUnit: UnitSpeed) {
        self.speedConverter = SpeedConverter(speed: speed)
        self.displayUnit = displayUnit
    }
    
    var body: some View {
        VStack {
            let speed = speedConverter.getSpeed(displayUnit)
            Text(speed.description)
                .font(.largeTitle)
                .bold()
                .contentTransition(.numericText())
                .animation(.bouncy(duration: 0.2), value: speed)
            Text("Top " + displayUnit.symbol)
                .opacity(0.6)
                .font(.caption)
        }
    }
}

#Preview {
    TrackTopSpeedView(48, displayUnit: .kilometersPerHour)
}
