//
//  TrackMapDetailView.swift
//  Routka
//
//  Created by vladukha on 04.04.2026.
//

import SwiftUI
import MapKit
import SimpleRouter

extension Route where Self == MeasuredTrackDetailView.RouteBuilder {
    /// View of a detailed measured track view
    static func mapTrackDetail(track: Track,
                            dependencies: DependencyManager) -> TrackMapDetailView.RouteBuilder {
        TrackMapDetailView.RouteBuilder(track: track, dependencies: dependencies)
    }
}

struct TrackMapDetailView: View {
    struct RouteBuilder: Route {
        static func == (lhs: TrackMapDetailView.RouteBuilder, rhs: TrackMapDetailView.RouteBuilder) -> Bool {
            lhs.track == rhs.track
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(track)
        }
        
        let track: Track
        let dependencies: DependencyManager

        func build() -> AnyView {
            AnyView(TrackMapDetailView(track: track,
                                    dependencies: dependencies))
        }
    }
    let track: Track
    let dependencies: DependencyManager
    var body: some View {
        MapView(mode: .free(track), dependencies: dependencies) {
            MapContents.speedTrack(track)
            if let start = track.points.first {
                MapContents.startPoint(start)
            }
            if let last = track.points.last {
                MapContents.stopPoint(last)
            }
        }
    }
}

#Preview {
    TrackMapDetailView(track: .filledTrack, dependencies: .mock())
}
