//
//  SpeedometerView.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import CoreLocation

struct SpeedometerView: View {
    private let speedConverter: SpeedConverter
    private let displayUnit: UnitSpeed
    
    init(_ speed: CLLocationSpeed, displayUnit: UnitSpeed) {
        self.speedConverter = SpeedConverter(speed: speed)
        self.displayUnit = displayUnit
    }
    
    var body: some View {
        VStack {
            Text(speedConverter.getSpeed(displayUnit).description)
                .font(.largeTitle)
                .frame(minWidth: 100)
                .bold()
            Text(displayUnit.symbol)
                .opacity(0.6)
                .font(.caption)
        }
        .padding()
        .glassEffect()
    }
}

#Preview {
    ZStack {
        Color.blue
        let speed: CLLocationSpeed = 32.6
        VStack {
            SpeedometerView(speed, displayUnit: .kilometersPerHour)
            SpeedometerView(speed, displayUnit: .metersPerSecond)
            SpeedometerView(speed, displayUnit: .milesPerHour)
        }
    }
}
