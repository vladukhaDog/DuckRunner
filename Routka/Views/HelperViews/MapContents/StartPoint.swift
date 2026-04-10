//
//  StartPointView.swift
//  Routka
//
//  Created by vladukha on 10.04.2026.
//


import SwiftUI
import MapKit

extension MapContents {
    /// Start point of a track
    @MapContentBuilder
    static public func startPoint(_ trackPoint: TrackPoint) -> some MapContent {
        
        Annotation(coordinate: trackPoint.position,
                   anchor: .bottom) {
            StartPointView()
        } label: {
        }

    }
}

struct StartPointView: View {
    var body: some View {
        VStack(spacing: 2) {
            Text(verbatim: "START")
                .font(.caption.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(.white)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(.green.gradient)
                )
            Triangle()
                .fill(.green.gradient)
                .frame(width: 12, height: 10)
                .stroke(color: .white.opacity(0.7))
        }
    }
}



#Preview {
    VStack {
        Map() {
            MapContents.speedTrack(.filledTrack)
            MapContents.startPoint(Track.filledTrack.points.first!)
        }
    }
}
#Preview("Inside View") {
    StartPointView()
}
