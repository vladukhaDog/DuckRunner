//
//  SpeedometerView.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import CoreLocation

/// `SpeedometerView` is a SwiftUI component that visually displays the user's current speed.
///
/// This view takes a speed value in meters per second and converts it to a desired display unit
/// (such as kilometers per hour, miles per hour, or meters per second). The converted speed is
/// prominently shown, along with the associated unit symbol. Suitable for fitness, navigation, and
/// transportation apps where real-time speed feedback is desired.
struct SpeedometerView: View {
    /// Converter that transforms the input speed (meters per second) to the chosen display unit.
    private let speedConverter: SpeedConverter
    
    /// The unit in which the speed should be presented (e.g., km/h, mph, m/s).
    private let displayUnit: UnitSpeed
    
    /// Creates a new `SpeedometerView`.
    /// - Parameters:
    ///   - speed: The current speed, in meters per second (CLLocationSpeed).
    ///   - displayUnit: The `UnitSpeed` to display the speed in (e.g., kilometers per hour).
    ///
    /// Initializes the internal speed converter and display unit.
    init(_ speed: CLLocationSpeed, displayUnit: UnitSpeed) {
        self.speedConverter = SpeedConverter(speed: speed)
        self.displayUnit = displayUnit
    }
    
    /// Displays the converted speed in a large, bold font, with the unit symbol beneath it.
    /// The layout uses padding and a glass effect for modern visual appeal.
    var body: some View {
        VStack {
            // Display the converted speed as a large, bold text
            Text(speedConverter.getSpeed(displayUnit).description)
                .font(.largeTitle)
                .frame(minWidth: 100) // Ensures width consistency across varying speed values
                .bold()
            
            // Display the unit symbol with reduced opacity and smaller font to give context
            Text(displayUnit.symbol)
                .opacity(0.6)
                .font(.caption)
        }
        .padding()
        .glassEffect() // Apply a visually appealing glass effect background
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

