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
    private(set) var screenState: ListState<Track> = .loading

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
            let loaded = await storage.getAllTracks(ofType: .import, limit: nil)
            withAnimation {
                self.screenState = .list(loaded)
            }
        }
    }
    
    /// Handles updates from the storage (track creation, deletion, or update) to maintain the correct tracks list.
    private func receiveAction(_ action: TrackStorageAction) {
        withAnimation {
            switch action {
            case .created(let track):
                guard track.trackType == .import else { return }
                if case .list(var array) = screenState {
                    let index = array.firstIndex(where: { $0.startDate > track.startDate }) ?? 0
                    array.insert(track, at: index)
                    self.screenState = .list(array)
                } else {
                    self.screenState = .list([track])
                }
                
            case .deleted(let track):
                guard track.trackType == .import else { return }
                if case .list(var array) = screenState {
                    array.removeAll(where: { $0.id == track.id })
                    self.screenState = .list(array)
                }
            case .updated(let track):
                guard track.trackType == .import else { return }
                if case .list(var array) = screenState {
                    if let index = array.firstIndex(where: { $0.id == track.id }) {
                        array[index] = track
                        self.screenState = .list(array)
                    }
                }
            }
        }
    }
}
