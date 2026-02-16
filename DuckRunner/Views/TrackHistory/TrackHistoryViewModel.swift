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
    @Published var selectedDate: Date = .now
    private let storage: any TrackStorageProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(storage: any TrackStorageProtocol) {
        self.storage = storage
        self.storage.actionPublisher
            .sink { [weak self] action in
                self?.receiveAction(action)
            }
            .store(in: &cancellables)
        
        self.$selectedDate
            .sink { date in
                Task {
                    let tracks = await storage.getTracks(for: date)
                    await MainActor.run {
                        withAnimation {
                            self.tracks = tracks
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
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
}
