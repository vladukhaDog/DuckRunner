//
//  TrackDetailView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import MapKit
import Combine

final class TrackDetailViewModel: ObservableObject {
    let track: Track
    init(track: Track) {
        self.track = track
    }
}

struct TrackDetailView: View {
    @StateObject private var vm: TrackDetailViewModel
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    init(track: Track) {
        self._vm = .init(wrappedValue: .init(track: track))
    }
    var body: some View {
        VStack {
            EqualFillHStack {
                let unitSpeed = UnitSpeed.byName(speedUnit)
                TrackTimeView(startDate: vm.track.startDate,
                              stopDate: vm.track.stopDate)
                let speed = vm.track.points.topSpeed() ?? 0
                TrackTopSpeedView(speed,
                                  displayUnit: unitSpeed)
                let distance = vm.track.points.totalDistance()
                TrackDistanceView(distance: distance,
                                  unit: unitSpeed.unitLength)
            }
            TrackMapSnippet(track: vm.track)
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
        }
        .navigationTitle("Track")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TrackDetailView(track: .filledTrack)
}
