//
//  StopPointAnnotation.swift
//  DuckRunner
//
//  Created by vladukha on 20.02.2026.
//
import MapKit

final class StopPointAnnotation: NSObject, FlagAnnotation {
    
    var outlineWidth: CGFloat = 4
    var coordinate: CLLocationCoordinate2D
    let title: String? = "Stop"
    let id: String = UUID().uuidString
    
    let annotationPointSize: CGFloat = 25
    
    var image: AnnotationImage = .init(image: "flag.pattern.checkered.2.crossed",
                                       fillColor: .green,
                                       strokeColor: .black)
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
