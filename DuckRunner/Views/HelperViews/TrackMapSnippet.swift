//
//  TrackMapSnippet.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import SwiftUI
import MapKit

struct TrackMapSnippet: View {
    let position: MapCameraPosition
    let track: Track
    init(track: Track) {
        self.track = track
        if let first = track.points.first?.position {
            let bounds = track.points.reduce(into: (minLat: first.latitude, maxLat: first.latitude, minLon: first.longitude, maxLon: first.longitude)) { (result, coord) in
                result.minLat = min(result.minLat, coord.position.latitude)
                result.maxLat = max(result.maxLat, coord.position.latitude)
                result.minLon = min(result.minLon, coord.position.longitude)
                result.maxLon = max(result.maxLon, coord.position.longitude)
                
            }
            let center = CLLocationCoordinate2D(latitude: (bounds.minLat + bounds.maxLat) / 2, longitude: (bounds.minLon + bounds.maxLon) / 2)
            
            let span = MKCoordinateSpan(latitudeDelta: bounds.maxLat - bounds.minLat + 0.01,
                                        longitudeDelta: bounds.maxLon - bounds.minLon + 0.01)
            print(span)
            self.position = .region(.init(center: center, span: span))
        } else {
            self.position = .automatic
        }
    }
    var body: some View {
        Map(position: .init(get: {position}, set: {_ in}), interactionModes: []) {
            if let start = track.points.first {
                Marker(coordinate: start.position) {
                    Text("Start")
                }
            }
            MapLine(points: track.points).line()
            if let stop = track.points.last {
                Marker(coordinate: stop.position) {
                    Text("Finish")
                }
            }
        }
    }
}
