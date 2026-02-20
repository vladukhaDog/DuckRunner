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
    
    enum MapViewMode {
        case trackUser
        case bounds(Track)
    }

    let overlays: [any MKOverlay]
    let markers: [any MKAnnotation]
    let mapMode: MapViewMode
    
    init(overlays: [any MKOverlay],
         markers: [any MKAnnotation] = [],
         mapMode: MapViewMode = .trackUser) {
        self.overlays = overlays
        self.mapMode = mapMode
        self.markers = markers
    }
    
    init(track: Track,
         markers: [any MKAnnotation] = [],
         mapMode: MapViewMode = .trackUser) {
        self.overlays = [SpeedTrackOverlay(track: track.points)]
        self.mapMode = mapMode
        self.markers = markers
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator

        // Interaction restrictions
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = true
        switch mapMode {
        case .trackUser:
            let camera = MKMapCamera()
            camera.pitch = 80
            camera.altitude = 80
            camera.heading = 0

            mapView.camera = camera
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.followWithHeading, animated: false)
        case .bounds(let track):
            mapView.showsUserLocation = false
            if let region = getRegion(for: track) {
                mapView.setRegion(region, animated: true)
            }
            for marker in markers {
                mapView.addAnnotation(marker)
            }
        }

//        if trackUser == false,
//           let points = track?.points,
//           let first = points.first?.position {
//            mapView.showsUserLocation = false
//            // ---- Static bounds mode ----
//

//            mapView.setRegion(region, animated: false)
//
//            // Add start and stop annotations
//            addStartStopAnnotations(to: mapView, from: points)
//        } else {
//            // ---- User tracking mode ----
//
//
//        }
        

        
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
//        mapView.removeAnnotations(mapView.annotations)
//        guard let trackPoints = track?.points else { return }
//        guard trackPoints.count > 1 else {
//            // If we have only one point or none, add start annotation if available
//            if trackPoints.count == 1 {
//                addStartStopAnnotations(to: mapView, from: trackPoints)
//            }
//            return
//        }

//        addStartStopAnnotations(to: mapView, from: trackPoints)

//        let overlay = SpeedTrackOverlay(track: trackPoints)
        overlays.forEach { overlay in
            mapView.addOverlay(overlay)
        }
        
    }
    
//    private func addStartStopAnnotations(to mapView: MKMapView, startPoint: TrackPoint,
//                                         stopPoint: TrackPoint) {
//        guard !points.isEmpty else { return }
//        let firstPos = points.first!.position
//        let lastPos = points.last!.position
//        
//        let startAnnotation = MKPointAnnotation()
//        startAnnotation.coordinate = firstPos
//        startAnnotation.title = "Start"
//        
//        // Add start annotation
//        mapView.addAnnotation(startAnnotation)
//        
//        // Add stop annotation only if it's different from start and track is finished
//        if self.track?.stopDate != nil,
//           (firstPos.latitude != lastPos.latitude || firstPos.longitude != lastPos.longitude) {
//            let stopAnnotation = MKPointAnnotation()
//            stopAnnotation.coordinate = lastPos
//            stopAnnotation.title = "Stop"
//            mapView.addAnnotation(stopAnnotation)
//        }
//    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    private func getRegion(for track: Track) -> MKCoordinateRegion? {
        let points = track.points
        guard points.count > 1,
              let first = points.first?.position else { return nil }
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
        return region
    }
}


extension TrackingMapView {

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay
        ) -> MKOverlayRenderer {
            return overlay.renderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Don't customize user location
            guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
            
            // Provide a custom view for StartPointAnnotation
            if let annotation = annotation as? FlagAnnotation {
                let identifier = "StartPointAnnotationView"
                let view: MKAnnotationView
                if let dequeued = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                    view = dequeued
                    view.annotation = annotation
                } else {
                    view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                }
                let image = annotation.makeImage()
                view.image = image
                view.canShowCallout = true
                view.centerOffset = CGPoint(x: 0, y: 0)
                return view
            }
            
            // Default: use a standard pin/marker for other annotations
            return nil
        }
    }
}





#Preview {
    TrackingMapView(overlays: [ReplayTrackOverlay(track: .roadInSPB)],
                    markers: [StartPointAnnotation(coordinate: Track.filledTrack.points.first!.position),
                              StopPointAnnotation(coordinate: Track.filledTrack.points.last!.position)],
                    mapMode: .bounds(.filledTrack))
                .ignoresSafeArea()
}

