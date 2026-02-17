//
//  CompactTrackAvgSpeedView.swift
//  DuckRunner
//
//  Created by vladukha on 17.02.2026.
//


import SwiftUI
import CoreLocation

/**
 A view that displays the average speed of a track in a compact format.

 - Parameters:
   - speed: The current speed value to be displayed, converted from CLLocationSpeed.
   - unit: The unit of speed measurement (e.g., kilometers per hour or miles per hour).
 */
struct CompactTrackAvgSpeedView: View {
    /// Converted speed to the used unit
    let speedValue: Int
    
    /// Unit of speed measurement
    let unit: UnitSpeed
    
    /**
     Initializes a new instance of `CompactTrackAvgSpeedView` with the given speed and unit.
     
     - Parameters:
       - speed: The current speed value in CLLocationSpeed format.
       - unit: The unit of speed measurement to be used for conversion.
     */
    init(speed: CLLocationSpeed, unit: UnitSpeed) {
        self.speedValue = SpeedConverter(speed: speed).getSpeed(unit)
        self.unit = unit
    }
    
    var body: some View {
        topSpeedWithAVG
    }
    
    /**
     A view that displays the speed value in bold text.
     
     - Returns: A `Text` view containing the speed value as a string.
     */
    private var speedText: some View {
        Text(speedValue.description)
            .bold()
    }
    
    /**
     A view that displays the unit symbol for the speed measurement.
     
     - Returns: A `Text` view containing the unit symbol.
     */
    private var unitText: some View {
        Text(unit.symbol)
    }
    
    /**
     Creates a system image view with the specified name.
     
     - Parameters:
       - name: The name of the system image to be displayed.
     - Returns: A `Image` view representing the specified system image.
     */
    private func icon(_ name: String) -> some View {
        Image(systemName: name)
    }
    
    /**
     A view that displays a text label indicating "avg" with styling.
     
     - Returns: A `Text` view containing "avg" in bold, padded background, and styled font.
     */
    private var avgIcon: some View {
       Text("avg")
            .bold()
            .padding(.horizontal, 2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.primary, lineWidth: 1)
            }
            .font(.caption2)
    }
    
    /**
     A view that displays the top speed with an icon and unit.
     
     - Returns: An `HStack` containing the gauge icon, speed text, and unit text.
     */
    private var topSpeedWithIcon: some View {
        HStack(spacing: 2) {
            icon("gauge.open.with.lines.needle.33percent.and.arrow.trianglehead.from.0percent.to.50percent")
            speedText
            unitText
        }
        .font(.caption)
        .opacity(0.6)
    }
    
    /**
     A view that displays the top speed with an "avg" label and unit.
     
     - Returns: An `HStack` containing the avg icon, speed text, and unit text.
     */
    private var topSpeedWithAVG: some View {
        HStack(spacing: 2) {
            avgIcon
            speedText
            unitText
        }
        .font(.caption)
        .opacity(0.6)
    }
}

#Preview {
    CompactTrackAvgSpeedView(speed: 32, unit: .kilometersPerHour)
}

