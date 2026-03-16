//
//  TrackDetailViewModel.swift
//  Routka
//
//  Created by vladukha on 16.03.2026.
//


import SwiftUI
import MapKit
import Combine
import SimpleRouter

/// View model responsible for managing and providing detailed track data 
/// for presentation in the TrackDetailView.
@Observable
final class TrackDetailViewModel {
    var showReplayButton: Bool {
        track.parentID == nil
    }
    var showEditSection: Bool {
        track.trackType != .import
    }
    var showDeleteTrackButton: Bool {
        self.children.isEmpty
    }
    var showReplaysSection: Bool {
        !children.isEmpty
    }
    var showExportButton: Bool {
        track.trackType != .import &&
        track.replayMode != .replay
    }
    var showModeEditButton: Bool {
        track.replayMode != .replay
    }
    var showTrimButton: Bool {
        track.parentID == nil &&
        children.isEmpty
    }
    
    /// Average speed of CLLocationSpeed
    var averageSpeed: CLLocationSpeed?
    var parentTrack: Track?
    var children: [Track] = []
    
    /// The track instance whose details are displayed.
    private(set) var track: Track
    private let storageService: any TrackStorageProtocol
    
    
    private var cancellables: Set<AnyCancellable> = []
    private let dependencies: DependencyManager
    /// Initializes the view model with a specific track.
    /// - Parameter track: The track to present.
    init(track: Track,
         dependencies: DependencyManager) {
        self.track = track
        self.storageService = dependencies.storageService
        self.dependencies = dependencies
        self.storageService.actionPublisher
            .sink { [weak self] action in
                self?.receiveAction(action)
            }
            .store(in: &cancellables)
        Task {
            if let parentID = track.parentID,
               let parent = await storageService.getTrack(by: parentID){
                await MainActor.run {
                    self.parentTrack = parent
                }
            } else {
                let children = await storageService.getTracks(withParentID: track.id, ofType: .record)
                await MainActor.run {
                    self.children = children
                }
            }
        }
    }
    
    /// Handles updates from the storage (track creation, deletion, or update) to maintain the correct tracks list.
    private func receiveAction(_ action: TrackStorageAction) {
        withAnimation {
            switch action {
            case .deleted(let track):
                if track.id == self.track.id {
                    dependencies.routers[dependencies.tabRouter.selectedTab]?
                        .pop()
                }
                self.children.removeAll(where: {$0.id == track.id})
            case .updated(let track):
                if track.id == self.track.id {
                    self.track = track
                }
                if let indexOfChild = self.children.firstIndex(where: {$0.id == track.id}) {
                    self.children[indexOfChild] = track
                }
            case .created(let track):
                if track.parentID == self.track.id {
                    self.children.append(track)
                }
            }
        }
    }
    
    func updateTrackType(to type: ReplayMode) async {
        self.track.replayMode = type
        try? await storageService.updateTrack(track)
    }
    
    func calculateAverageSpeed() {
        let points = track.points
        guard !points.isEmpty,
        let stopDate = track.stopDate else {
            return
        }

        // Calculate total distance traveled
        let totalDistance = points.totalDistance()
        
        // Calculate total time (in seconds)
        let totalTime = (stopDate.timeIntervalSince(track.startDate))
        
        // Guard against zero or near-zero time
        guard totalTime > 0 else {
            return
        }

        // Average speed in m/s
        let averageSpeedInMetersPerSecond = totalDistance / totalTime
        
        // Set the average speed (m/s)
        self.averageSpeed = CLLocationSpeed(averageSpeedInMetersPerSecond)
    }
    
    
}
