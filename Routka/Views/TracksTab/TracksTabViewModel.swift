//
//  TracksTabViewModel.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//
import SwiftUI
import Combine

@Observable
final class TracksTabViewModel: TracksTabViewModelProtocol {
    var historyTracks: [Track] = []
    var measuredTracks: [MeasuredTrack] = []
    var importedTracks: [Track] = []
    
    private let dependencies: DependencyManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(dependencies: DependencyManager) {
        self.dependencies = dependencies
        
        Task {
            let historyTracks = await dependencies.storageService
                .getAllTracks(ofType: .record, limit: 6)
            withAnimation {
                self.historyTracks = historyTracks
            }
        }
        Task {
            let importedTracks = await dependencies.storageService
                .getAllTracks(ofType: .import, limit: 6)
            withAnimation {
                self.importedTracks = importedTracks
            }
        }
        
        Task {
            let measuredTracks = await dependencies.measuredTrackStorageService
                .getMeasuredTracks(limit: 6)
            withAnimation {
                self.measuredTracks = measuredTracks
            }
        }
        
        self.dependencies.storageService
            .actionPublisher
            .sink { [weak self] action in
                self?.receiveAction(action)
            }
            .store(in: &cancellables)
        self.dependencies.measuredTrackStorageService
            .actionPublisher
            .sink { [weak self] action in
                self?.receiveAction(action)
            }
            .store(in: &cancellables)
    }
    
    private func receiveAction(_ action: MeasuredTrackStorageAction) {
        switch action {
        case .created(let track):
            guard measuredTracks.count < 6 else { return }
            // Insert track by descending startDate order
            if let index = measuredTracks.firstIndex(where: { $0.startDate > track.startDate }) {
                measuredTracks.insert(track, at: index)
            } else {
                measuredTracks.insert(track, at: 0)
            }
        case .deleted(let track):
            measuredTracks.removeAll(where: { $0.id == track.id })
        case .updated(let track):
            if let index = measuredTracks.firstIndex(where: { $0.id == track.id }) {
                measuredTracks[index] = track
            }
        }
    }
    
    private func receiveAction(_ action: TrackStorageAction) {
        withAnimation {
            switch action {
            case .created(let track):
                switch track.trackType {
                case .record:
                    guard historyTracks.count < 6 else { return }
                    let index = self.historyTracks.firstIndex(where: { $0.startDate > track.startDate }) ?? 0
                    self.historyTracks.insert(track, at: index)
                case .import:
                    guard importedTracks.count < 6 else { return }
                    let index = self.importedTracks.firstIndex(where: { $0.startDate > track.startDate }) ?? 0
                    self.importedTracks.insert(track, at: index)
                case .measurement:
                    break
                }
                
            case .deleted(let track):
                self.historyTracks.removeAll(where: { $0.id == track.id })
                self.importedTracks.removeAll(where: { $0.id == track.id })
            case .updated(let track):
                if let index = self.historyTracks.firstIndex(where: { $0.id == track.id }) {
                    self.historyTracks[index] = track
                } else if let index = self.importedTracks.firstIndex(where: { $0.id == track.id }) {
                    self.importedTracks[index] = track
                }
            }
        }
    }
}
