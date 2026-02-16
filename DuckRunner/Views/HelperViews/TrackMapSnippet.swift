//
//  TrackMapSnippet.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import SwiftUI
import MapKit

struct TrackMapSnippet: View {
    let track: Track
    init(track: Track) {
        self.track = track
    }
    var body: some View {
        TrackingMapView(track: track, trackUser: false)
    }
}
