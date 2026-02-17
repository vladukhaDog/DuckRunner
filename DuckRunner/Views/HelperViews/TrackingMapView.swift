//
//  TrackingMapView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import MapKit
import SwiftUI
import UIKit

/// UIKit bridged MapView with track rendering and user location following
struct TrackingMapView: UIViewRepresentable {

    let track: Track?
    let trackUser: Bool
    
    init(track: Track? = nil, trackUser: Bool = true) {
        self.track = track
        self.trackUser = trackUser
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator

        // Interaction restrictions
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = true

        if trackUser == false,
           let points = track?.points,
           let first = points.first?.position {
            mapView.showsUserLocation = false
            // ---- Static bounds mode ----

            let bounds = points.reduce(
                into: (
                    minLat: first.latitude,
                    maxLat: first.latitude,
                    minLon: first.longitude,
                    maxLon: first.longitude
                )
            ) { result, point in
                result.minLat = min(result.minLat, point.position.latitude)
                result.maxLat = max(result.maxLat, point.position.latitude)
                result.minLon = min(result.minLon, point.position.longitude)
                result.maxLon = max(result.maxLon, point.position.longitude)
            }

            let center = CLLocationCoordinate2D(
                latitude: (bounds.minLat + bounds.maxLat) / 2,
                longitude: (bounds.minLon + bounds.maxLon) / 2
            )

            let span = MKCoordinateSpan(
                latitudeDelta: (bounds.maxLat - bounds.minLat) * 2,
                longitudeDelta: (bounds.maxLon - bounds.minLon) * 2
            )

            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: false)

            // Add start and stop annotations
            addStartStopAnnotations(to: mapView, from: points)
        } else {
            // ---- User tracking mode ----

            mapView.showsUserLocation = true

            let camera = MKMapCamera()
            camera.pitch = 80
            camera.altitude = 80
            camera.heading = 0

            mapView.camera = camera
            mapView.setUserTrackingMode(.followWithHeading, animated: false)
        }

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        guard let trackPoints = track?.points else { return }
        guard trackPoints.count > 1 else {
            // If we have only one point or none, add start annotation if available
            if trackPoints.count == 1 {
                addStartStopAnnotations(to: mapView, from: trackPoints)
            }
            return
        }

        addStartStopAnnotations(to: mapView, from: trackPoints)

        let overlay = SpeedTrackOverlay(track: trackPoints)
        mapView.addOverlay(overlay)
    }
    
    private func addStartStopAnnotations(to mapView: MKMapView, from points: [TrackPoint]) {
        guard !points.isEmpty else { return }
        let firstPos = points.first!.position
        let lastPos = points.last!.position
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = firstPos
        startAnnotation.title = "Start"
        
        // Add start annotation
        mapView.addAnnotation(startAnnotation)
        
        // Add stop annotation only if it's different from start and track is finished
        if self.track?.stopDate != nil,
           (firstPos.latitude != lastPos.latitude || firstPos.longitude != lastPos.longitude) {
            let stopAnnotation = MKPointAnnotation()
            stopAnnotation.coordinate = lastPos
            stopAnnotation.title = "Stop"
            mapView.addAnnotation(stopAnnotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}


extension TrackingMapView {

    final class Coordinator: NSObject, MKMapViewDelegate {

        func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay
        ) -> MKOverlayRenderer {
            if overlay is SpeedTrackOverlay {
                return SpeedTrackRenderer(overlay: overlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}





#Preview {
    TrackingMapView(track: Track.filledTrack, trackUser: false)
                .ignoresSafeArea()
}

