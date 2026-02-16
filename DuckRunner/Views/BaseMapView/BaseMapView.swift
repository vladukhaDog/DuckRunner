//
//  BaseMapView.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import MapKit


/// Convenience initializer for standard setup with required services.
extension BaseMapView where ViewModel == BaseMapViewModel {
    init(trackService: any TrackServiceProtocol,
         locationService: any LocationServiceProtocol,
         storageService: any TrackStorageProtocol) {
        self.init(vm: BaseMapViewModel(trackService: trackService,
                                       locationService: locationService,
                                       storageService: storageService))
    }
}


/// View for displaying an interactive map and current tracking information, including speed and live track data.
/// Hosts overlays for live speed and track info, and manages user tracking controls.
struct BaseMapView<ViewModel: BaseMapViewModelProtocol>: View {
    /// The view model providing current track, speed, and control actions for the map.
    @StateObject private var vm: ViewModel
    /// User's preferred unit for speed display (persisted in app storage).
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    
    /// Creates a new map view bound to the provided view model instance.
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    /// The main interface for map display, overlays, and controls.
    var body: some View {
        let unitSpeed = UnitSpeed.byName(speedUnit)
        TrackingMapView(track: vm.currentTrack, trackUser: true)
            .ignoresSafeArea(.all)
            .overlay(alignment: .top) {
                if let currentSpeed = vm.currentSpeed {
                    SpeedometerView(currentSpeed, displayUnit: unitSpeed)
                        .transition(.opacity)
                }
            }
            .overlay(alignment: .bottom, content: {
                VStack {
                    if let track = vm.currentTrack {
                        TrackLiveInfoView(track: track, unit: unitSpeed)
                    }
                    TrackControlButton(vm: vm)
                }
                .padding(10)
                
            })
            .animation(.bouncy, value: vm.currentSpeed != nil)
    }
}

import Combine
private final class PreviewModel: BaseMapViewModelProtocol {
    @Published var currentTrack: Track?
    
    @Published var currentPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @Published var currentSpeed: CLLocationSpeed? = 0
    
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
