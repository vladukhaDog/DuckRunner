//
//  StartPointAnnotation.swift
//  DuckRunner
//
//  Created by vladukha on 20.02.2026.
//

import Foundation
import MapKit

final class StartPointAnnotation: NSObject, FlagAnnotation {
    let annotationPointSize: CGFloat = 20
    
    var image: AnnotationImage = .init(image: "mappin",
                                       fillColor: .lightGray,
                                       strokeColor: .black)
    
    
    var outlineWidth: CGFloat = 3
    
    var coordinate: CLLocationCoordinate2D
    let title: String? = "Start"
    let id: String = UUID().uuidString
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
