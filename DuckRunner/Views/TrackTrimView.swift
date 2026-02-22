//
//  TrackTrimView.swift
//  DuckRunner
//
//  Created by vladukha on 23.02.2026.
//

import SwiftUI

struct TrackTrimView: View {
    let track: Track
    init(track: Track,
         dependencies: DependencyManager) {
        self.track = track
    }
    var body: some View {
        TrackingMapView(overlays: [FantomTrackOverlay(track: track.points)], mapMode: .bounds(track))
    }
}

#Preview {
    TrackTrimView(track: .filledTrack, dependencies: .mock())
}
