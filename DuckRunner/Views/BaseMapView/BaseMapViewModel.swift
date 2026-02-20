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
    

    @Published var currentSpeed: CLLocationSpeed? = 0
    
    @Published var replayTrack: Track? = nil
    
    func startTrack() {
        self.trackService.startTrack(at: .now)
        
        // Prevent the device from sleeping during track recording
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopTrack() throws {
        let track = try self.trackService.stopTrack(at: .now)
        Task.detached { [weak self] in
            try? await self?.storageService.addTrack(track)
        }
        
        // Re-enable the idle timer after stopping the track
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    let trackService: any LiveTrackServiceProtocol
    let locationService: any LocationServiceProtocol
    let storageService: any TrackStorageProtocol
    let trackReplayCoordinator: any TrackReplayCoordinatorProtocol
    
    private var replayValidator: TrackReplayValidator? = nil
    
    private var locationPublisher: AnyCancellable?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private func receivedLocationUpdate(_ location: CLLocation) {
        let trackPoint: TrackPoint = .init(position: location.coordinate,
                               speed: max(0,location.speed),
                               date: .now)
        try? self.trackService.appendTrackPosition(trackPoint)
        Task.detached {
            await self.replayValidator?.passedPoint(trackPoint)
        }
        self.currentSpeed = max(0,location.speed)
    }
    
    init(trackService: any LiveTrackServiceProtocol,
         locationService: any LocationServiceProtocol,
         storageService: any TrackStorageProtocol,
         trackReplayCoordinator: any TrackReplayCoordinatorProtocol) {
        self.trackReplayCoordinator = trackReplayCoordinator
        self.trackService = trackService
        self.locationService = locationService
        self.storageService = storageService
        
        self.trackReplayCoordinator
            .selectedTrackPublisher
            .receive(on: RunLoop.main)
            .sink { action in
                switch action {
                case .select(let track):
                    self.replayTrack = track
                    self.replayValidator = .init(replayingTrack: track)
                case .deselect:
                    self.replayTrack = nil
                    self.replayValidator = nil
                }
            }
            .store(in: &cancellables)
        
        self.trackService
            .currentTrack
            .assign(to: &self.$currentTrack)
        
        self.locationService.location
            .sink { [weak self] location in
                self?.receivedLocationUpdate(location)
            }
            .store(in: &cancellables)
    }
    
}

