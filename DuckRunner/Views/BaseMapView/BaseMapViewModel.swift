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
    let mapMode: TrackingMapView.MapViewMode = .trackUser
    @Published var isTrackControlAvailable: Bool = true
    
    @Published var currentTrack: Track? = nil
    
    @Published var currentSpeed: CLLocationSpeed? = 0
    
    @Published var replayTrack: Track? = nil
    @Published var checkpoints: [TrackCheckPoint] = []
    
    private var startReplayCheckpoint: TrackCheckPoint?
    private var stopReplayCheckpoint: TrackCheckPoint?
    
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
            guard var checkpoints = await self.replayValidator?.checkpoints.map({$0.value})
                .sorted(by: {$0.point.date < $1.point.date}) else { return }
            if let start = await self.startReplayCheckpoint {
                checkpoints.insert(start, at: 0)
            }
            let lockedCheckpoints = checkpoints
            await MainActor.run {
                self.checkpoints = lockedCheckpoints
            }
        }
        self.currentSpeed = max(0,location.speed)
        
        checkIfInReplayCheckpoint(location)
    }
    
    private func checkIfInReplayCheckpoint(_ location: CLLocation) {
        // Track is not started yet
        if currentTrack == nil {
            if self.startReplayCheckpoint?.checkPointPassed == false,
                startReplayCheckpoint?.isPointInCheckpoint(location.coordinate) == true {
                self.startReplayCheckpoint?.setCheckpointPassing(to: true)
                if location.speed > 15 {
                    self.startTrack()
                    self.isTrackControlAvailable = true
                } else {
                    self.isTrackControlAvailable = true
                }
            }
        } else {
            // Track is being recorded already
            if  self.stopReplayCheckpoint?.checkPointPassed == false,
                stopReplayCheckpoint?.isPointInCheckpoint(location.coordinate) == true {
                self.stopReplayCheckpoint?.setCheckpointPassing(to: true)
                self.isTrackControlAvailable = true
                try? self.stopTrack()
            }
        }
        
    }
    
    func receiveReplayTrackAction(_ action: TrackReplayAction) {
        switch action {
        case .select(let track):
            self.replayTrack = track
            self.replayValidator = .init(replayingTrack: track)
            self.isTrackControlAvailable = false
            if let firstPoint = replayTrack?.points.first {
                let checkpoint = TrackCheckPoint(point: firstPoint, distanceThreshold: 50)
                self.startReplayCheckpoint = checkpoint
            }
            if let lastPoint = replayTrack?.points.last {
                let checkpoint = TrackCheckPoint(point: lastPoint, distanceThreshold: 50)
                self.stopReplayCheckpoint = checkpoint
            }
        case .deselect:
            self.replayTrack = nil
            self.replayValidator = nil
            self.isTrackControlAvailable = true
            self.stopReplayCheckpoint = nil
            self.startReplayCheckpoint = nil
        }
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
            .sink {[weak self] action in
                self?.receiveReplayTrackAction(action)
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

