//
//  StartPointView 2.swift
//  Routka
//
//  Created by vladukha on 10.04.2026.
//



import SwiftUI
import MapKit

extension MapContents {
    /// Start point of a track
    @MapContentBuilder
    static public func stopPoint(_ trackPoint: TrackPoint) -> some MapContent {
        
        Annotation(coordinate: trackPoint.position,
                   anchor: .bottom) {
            StopPointView()
        } label: {
        }

    }
}

struct StopPointView: View {
    var body: some View {
        VStack(spacing: 2) {
            Text(verbatim: "STOP")
                .font(.caption.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(.white)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(.mint.gradient)
                )
            Triangle()
                .fill(.mint.gradient)
                .frame(width: 12, height: 10)
                .stroke(color: .orange.opacity(0.7))
        }
        
    }
}



#Preview {
    VStack {
        Map() {
            MapContents.speedTrack(.filledTrack)
            MapContents.stopPoint(Track.filledTrack.points.last!)
        }
    }
}
#Preview("Inside View") {
    StopPointView()
}
