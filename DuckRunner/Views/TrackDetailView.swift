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
    
    
    /// Average speed of CLLocationSpeed
    @Published var averageSpeed: CLLocationSpeed?
    
    /// Initializes the view model with a specific track.
    /// - Parameter track: The track to present.
    init(track: Track) {
        self.track = track
    }
    
    func calculateAverageSpeed() {
        let points = track.points
        guard !points.isEmpty,
        let stopDate = track.stopDate else {
            return
        }

        // Calculate total distance traveled
        let totalDistance = points.totalDistance()
        
        // Calculate total time (in seconds)
        let totalTime = (stopDate.timeIntervalSince(track.startDate))
        
        // Guard against zero or near-zero time
        guard totalTime > 0 else {
            return
        }

        // Average speed in m/s
        let averageSpeedInMetersPerSecond = totalDistance / totalTime
        
        // Set the average speed (m/s)
        self.averageSpeed = CLLocationSpeed(averageSpeedInMetersPerSecond)
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
        VStack(spacing: 15) {
            
            
            // Map snippet showing the recorded track route.
            TrackMapSnippet(track: vm.track)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            mainStat
            topSpeed
            Spacer()
            
        }
        .padding()
        .onAppear(perform: {
            self.vm.calculateAverageSpeed()
        })
        .navigationTitle("Track")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var topSpeed: some View {
        if let speed = vm.track.points.topSpeed() {
            let unitSpeed = UnitSpeed.byName(speedUnit)
            HStack {
                TrackTopSpeedView(speed,
                                  displayUnit: unitSpeed)
                .padding()
                .glassEffect(.regular.tint(.cyan.opacity(0.1)), in: RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
        }
    }
    
    private var mainStat: some View {
        HStack {
            let unitSpeed = UnitSpeed.byName(speedUnit)
            CompactTrackDistanceView(distance: vm.track.points.totalDistance(),
                                     unit: unitSpeed)
            Spacer()
            if let stopDate = vm.track.stopDate {
                CompactTrackDurationView(startDate: vm.track.startDate,
                                         stopDate: stopDate)
            }
            Spacer()
           if let averageSpeed = vm.averageSpeed {
               CompactTrackAvgSpeedView(speed: averageSpeed,
                                        unit: unitSpeed)
            }
        }
    }
}

#Preview {
    TrackDetailView(track: .filledTrack)
}
