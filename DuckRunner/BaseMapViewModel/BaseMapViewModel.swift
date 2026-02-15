//
//  BaseMapViewModel.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import SwiftUI
import Combine
import MapKit


final class BaseMapViewModel: BaseMapViewModelProtocol {
    @Published var currentTrack: Track? = nil
    
    @Published var currentPosition: MapCameraPosition = .userLocation(followsHeading: true,
                                                                      fallback: .automatic)

    @Published var currentSpeed: CLLocationSpeed? = nil
    
    func startTrack() {
        self.trackService.startTrack(at: .now)
    }
    
    func stopTrack() throws {
        try self.trackService.stopTrack(at: .now)
    }
    
    
    let trackService: any TrackServiceProtocol
    let locationService: any LocationServiceProtocol
    
    private var locationPublisher: AnyCancellable?
    
    init(trackService: any TrackServiceProtocol,
         locationService: any LocationServiceProtocol) {
        self.trackService = trackService
        self.locationService = locationService
        
        self.trackService
            .currentTrack
            .assign(to: &self.$currentTrack)
        
        self.locationPublisher = self.locationService.location
            .sink { [weak self] location in
                try? self?.trackService.appendTrackPosition(.init(position: location.coordinate, speed: location.speed))
                self?.currentSpeed = location.speed
            }
    }
    
}
