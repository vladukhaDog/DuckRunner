//
//  CompactTrackAvgSpeedView.swift
//  DuckRunner
//
//  Created by vladukha on 17.02.2026.
//


import SwiftUI
import CoreLocation

struct CompactTrackAvgSpeedView: View {
    /// converted speed to used unit
    let speed: Int
    let unit: UnitSpeed
    
    init(speed: CLLocationSpeed, unit: UnitSpeed) {
        
        self.speed = SpeedConverter(speed: speed).getSpeed(unit)
        self.unit = unit
    }
    var body: some View {
        topSpeed
    }
    
    private var topSpeed: some View {
        HStack(spacing: 2) {
            Image(systemName: "gauge.with.dots.needle.33percent")
            Text(speed.description)
                .bold()
            Text(unit.symbol)
        }
        .font(.caption)
        .opacity(0.6)
    }
}
