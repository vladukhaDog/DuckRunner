//
//  BaseMapView.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import MapKit


extension BaseMapView where ViewModel == BaseMapViewModel {
    init(trackService: any TrackServiceProtocol,
         locationService: any LocationServiceProtocol,
         storageService: any TrackStorageProtocol) {
        self.init(vm: BaseMapViewModel(trackService: trackService,
                                       locationService: locationService,
                                       storageService: storageService))
    }
}

struct BaseMapView<ViewModel: BaseMapViewModelProtocol>: View {
    @StateObject private var vm: ViewModel
    
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View {
        Map(position: $vm.currentPosition) {
            UserAnnotation()
            if let points = vm.currentTrack?.points {
                MapPolyline(points: points.map({ point in
                    MKMapPoint(point.position)
                }), contourStyle: .straight)
                .stroke(Color.cyan,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin: .round
                        ))
            }
        }
        .mapControls {
            // Optional: Add a built-in button for the user to re-center the map
            MapUserLocationButton()
        }
        .safeAreaInset(edge: .top, content: {
            if let currentSpeed = vm.currentSpeed {
                SpeedometerView(currentSpeed, displayUnit: .kilometersPerHour)
                    .transition(.opacity)
            }
        })
        .overlay(alignment: .bottom, content: {
            TrackInfoView(vm: vm, unit: .kilometersPerHour)
        })
        .animation(.bouncy, value: vm.currentSpeed != nil)
    }
}

import Combine
private final class PreviewModel: BaseMapViewModelProtocol {
    @Published var currentTrack: Track?
    
    @Published var currentPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @Published var currentSpeed: CLLocationSpeed? = nil
    
    func startTrack() {
        self.currentSpeed = 35.553
    }
    
    func stopTrack() {
        self.currentSpeed = nil
    }
    
}

#Preview {
    BaseMapView(vm: PreviewModel())
}
