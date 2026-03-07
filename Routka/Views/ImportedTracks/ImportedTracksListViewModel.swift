//
//  ImportedTracksListViewModel.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//
import SwiftUI
import Combine

/// View model for the imported tracks list
@Observable
final class ImportedTracksListViewModel: ImportedTracksListViewModelProtocol {
    private(set) var tracks: [Track] = []
    private let storage: any TrackStorageProtocol
    
    private var cancellables: Set<AnyCancellable> = []

    init(dependencies: DependencyManager) {
        self.storage = dependencies.storageService
        
        self.storage.actionPublisher
            .sink { [weak self] action in
                self?.receiveAction(action)
            }
            .store(in: &cancellables)
        
        // Load imported tracks
        Task {
            let loaded = await storage.getAllTracks(ofType: .import)
            withAnimation {
                self.tracks = loaded
            }
        }
    }
    
    /// Handles updates from the storage (track creation, deletion, or update) to maintain the correct tracks list.
    private func receiveAction(_ action: TrackStorageAction) {
        withAnimation {
            switch action {
            case .created(let track):
                guard track.trackType == .import else { return }
                let index = self.tracks.firstIndex(where: { $0.startDate > track.startDate }) ?? 0
                self.tracks.insert(track, at: index)
            case .deleted(let track):
                guard track.trackType == .import else { return }
                self.tracks.removeAll(where: { $0.id == track.id })
            case .updated(let track):
                guard track.trackType == .import else { return }
                if let index = self.tracks.firstIndex(where: { $0.id == track.id }) {
                    self.tracks[index] = track
                }
            }
        }
    }
}
