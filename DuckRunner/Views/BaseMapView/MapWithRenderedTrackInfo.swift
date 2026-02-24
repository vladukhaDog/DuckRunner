//
//  MapWithRenderedTrackInfo.swift
//  DuckRunner
//
//  Created by vladukha on 21.02.2026.
//
import SwiftUI
import MapKit

struct MapWithRenderedTrackInfo: View {
    
    static func createMarkers(currentTrack: Track?,
                        replayTrack: Track?,
                       checkpoints: [TrackCheckPoint]) -> [any MKAnnotation] {
        var array: [any MKAnnotation] = []
        if let finish = replayTrack?.points.last {
            array.append(StopPointAnnotation(coordinate: finish.position))
        }
        for checkpoint in checkpoints {
            array.append(CheckpointAnnotation(coordinate: checkpoint.point.position,
                                              passed: checkpoint.checkPointPassed))
        }
        
        return array
    }
    
    static func createOverlays(currentTrack: Track?,
                        replayTrack: Track?) -> [any MKOverlay] {
        var array: [any MKOverlay] = []
        // Order will stay for the rendering
        if let track = replayTrack {
            array.append(ReplayTrackOverlay(track: track.points))
        }
        if let track = currentTrack {
            array.append(SpeedTrackOverlay(track: track.points))
        }
        return array
    }
    
    
    init(currentTrack: Track?,
         replayTrack: Track?,
        checkpoints: [TrackCheckPoint],
         mapMode: TrackingMapView.MapViewMode = .trackUser) {
        self.overlays = Self.createOverlays(currentTrack: currentTrack,
                                       replayTrack: replayTrack)
        self.mapMode = mapMode
        self.markers = Self.createMarkers(currentTrack: currentTrack, replayTrack: replayTrack, checkpoints: checkpoints)
    }
    private let mapMode: TrackingMapView.MapViewMode
    private let markers: [any MKAnnotation]
    private let overlays: [any MKOverlay]
    
    var body: some View {
        return TrackingMapView(overlays: overlays,
                        markers: markers,
                        mapMode: mapMode)
    }
    
    
}
