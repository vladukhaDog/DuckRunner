//
//  TrackHistoryViewModel.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import SwiftUI
import Combine

final class TrackHistoryViewModel: TrackHistoryViewModelProtocol {
    @Published private(set) var tracks: [Track] = []
    private let storage: any TrackStorageProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(storage: any TrackStorageProtocol) {
        self.storage = storage
        self.storage.actionPublisher
            .sink { [weak self] action in
                print("updated", action)
                self?.receiveAction(action)
            }
            .store(in: &cancellables)
        Task {
            let tracks = await storage.getAllTracks()
            await MainActor.run {
                withAnimation {
                    self.tracks = tracks
                }
            }
        }
    }
    
    private func receiveAction(_ action: StorageAction) {
        withAnimation {
            switch action {
            case .created(let track):
                let index = self.tracks.firstIndex(where: { $0.startDate > track.startDate }) ?? 0
                self.tracks.insert(track, at: index)
            case .deleted(let track):
                self.tracks.removeAll(where: { $0.id == track.id })
            case .updated(let track):
                if let index = self.tracks.firstIndex(where: { $0.id == track.id }) {
                    self.tracks[index] = track
                }
            }
        }
    }
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let track = tracks[index]
            Task {
                await self.storage.deleteTrack(track)
            }
            withAnimation {
                let _ = self.tracks.remove(at: index)
            }
        }
    }
}
