//
//  StopPoint.swift
//  Routka
//
//  Created by vladukha on 26.02.2026.
//
import MapKit
import SwiftUI

extension MapContents {
    /// Stop checkpoint
    @MapContentBuilder
    static public func stopPoint(_ trackPoint: TrackPoint) -> some MapContent {
        
        Annotation(coordinate: trackPoint.position,
                   anchor: .bottom) {
            StopPointView(trackPoint: trackPoint)
        } label: {
        }

    }
}

private struct StopPointView: View {
    let trackPoint: TrackPoint
    
    private var icon: some View {
        Image(systemName: "flag.pattern.checkered.2.crossed")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.green)
            .stroke(color: .black, width: 0.2)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("FINISH")
                .font(.caption)
                .stroke(color: .black, width: 0.5)
            .bold()
            icon
        }
    }
}

#Preview {
    VStack {
        Map() {
            MapContents.speedTrack(.filledTrack)
            MapContents.stopPoint(Track.filledTrack.points.first!)
        }
    }
}

#Preview("Inside View") {
    StopPointView(trackPoint: Track.filledTrack.points.first!)
}
