//
//  TrackDetailView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
// This file contains the UI components and view model necessary to present
// detailed information about a recorded track. It displays key metrics such as
// time, top speed, distance, and a map snippet showing the track route,
// providing users with a comprehensive history and summary of their finished tracks.
//

import SwiftUI
import MapKit
import Combine

/// View model responsible for managing and providing detailed track data 
/// for presentation in the TrackDetailView.
final class TrackDetailViewModel: ObservableObject {
    /// The track instance whose details are displayed.
    let track: Track
    
    /// Initializes the view model with a specific track.
    /// - Parameter track: The track to present.
    init(track: Track) {
        self.track = track
    }
}

/// A detailed view presenting comprehensive information about a finished track.
/// This view uses `TrackDetailViewModel` as its source of truth,
/// and serves as a detail/history screen displaying time, speed, distance,
/// and a map snippet of the track route.
struct TrackDetailView: View {
    /// View model instance managing the track data and logic.
    @StateObject private var vm: TrackDetailViewModel
    
    /// User preference stored for the speed unit (e.g., km/h or mph).
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    
    /// Creates the detail view with the given track.
    /// - Parameter track: The track to be detailed.
    init(track: Track) {
        self._vm = .init(wrappedValue: .init(track: track))
    }
    
    /// The main UI body of the detail view.
    /// It is composed of:
    /// - A horizontally filling stack displaying time, top speed, and distance metrics.
    /// - A map snippet showing the route of the track with styling.
    var body: some View {
        VStack {
            // Horizontal stack filling width with key track metrics:
            // time, top speed, and distance.
            EqualFillHStack {
                // Obtain the speed unit for display from user preference.
                let unitSpeed = UnitSpeed.byName(speedUnit)
                
                // Display the start and stop times of the track.
                TrackTimeView(startDate: vm.track.startDate,
                              stopDate: vm.track.stopDate)
                
                // Calculate the top speed from the track's points for display.
                let speed = vm.track.points.topSpeed() ?? 0
                
                // Display the top speed with the proper unit.
                TrackTopSpeedView(speed,
                                  displayUnit: unitSpeed)
                
                // Calculate the total distance of the track.
                let distance = vm.track.points.totalDistance()
                
                // Display the distance with the unit corresponding to the speed unit.
                TrackDistanceView(distance: distance,
                                  unit: unitSpeed.unitLength)
            }
            // Map snippet showing the recorded track route.
            TrackMapSnippet(track: vm.track)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
        }
        .navigationTitle("Track")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Preview provider demonstrating the TrackDetailView with a sample filled track.
#Preview {
    TrackDetailView(track: .filledTrack)
}
