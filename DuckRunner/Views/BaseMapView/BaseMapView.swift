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
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View {
        let unitSpeed = UnitSpeed.byName(speedUnit)
        Map(position: $vm.currentPosition) {
            UserAnnotation()
            if let points = vm.currentTrack?.points {
                MapLine(points: points).line()
            }
        }
        .mapControls {
            // Optional: Add a built-in button for the user to re-center the map
            MapUserLocationButton()
        }
        .safeAreaInset(edge: .top, content: {
            if let currentSpeed = vm.currentSpeed {
                SpeedometerView(currentSpeed, displayUnit: unitSpeed)
                    .transition(.opacity)
            }
        })
        .overlay(alignment: .bottom, content: {
            VStack {
                if let track = vm.currentTrack {
                    TrackInfoView(track: track, unit: unitSpeed)
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
