//
//  TrackHistoryView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import Combine

extension TrackHistoryView where ViewModel == TrackHistoryViewModel {
    init(storage: any TrackStorageProtocol,
         mapSnapshotGenerator: any MapSnapshotGeneratorProtocol,
         mapSnippetCache: any TrackMapSnippetCacheProtocol) {
        self.init(vm: .init(storage: storage),
                  mapSnapshotGenerator: mapSnapshotGenerator,
                  mapSnippetCache: mapSnippetCache)
    }
}

/// Root view for displaying the user's track history with date-based navigation and detail view links.
struct TrackHistoryView<ViewModel: TrackHistoryViewModelProtocol>: View {
    /// The view model managing and providing track history data and selection.
    @StateObject private var vm: ViewModel
    /// User's preferred unit for speed display, persisted locally.
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    
    let mapSnapshotGenerator: any MapSnapshotGeneratorProtocol
    let mapSnippetCache: any TrackMapSnippetCacheProtocol
    
    /// Initializes the history view with the given view model.
    init(vm: ViewModel,
         mapSnapshotGenerator: any MapSnapshotGeneratorProtocol,
         mapSnippetCache: any TrackMapSnippetCacheProtocol) {
        self._vm = .init(wrappedValue: vm)
        self.mapSnippetCache = mapSnippetCache
        self.mapSnapshotGenerator = mapSnapshotGenerator
    }
    
    /// The main UI displaying history list, navigation links, and date selector.
    var body: some View {
        NavigationView {
            ScrollView {
                dateSelector
                Divider()
                LazyVStack(spacing: 5) {
                    if vm.tracks.isEmpty {
                        Text("Empty history")
                            .font(.largeTitle)
                            .opacity(0.6)
                            .transition(.opacity)
                    }
                    ForEach(vm.tracks, id: \.startDate) { track in
                        NavigationLink {
                            TrackDetailView(track: track)
                        } label: {
                            TrackHistoryCellView(track: track,
                                                 unit: UnitSpeed.byName(speedUnit),
                                             mapSnapshotGenerator: mapSnapshotGenerator,
                                             mapSnippetCache: mapSnippetCache)
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .animation(.default, value: vm.tracks.isEmpty)
            .navigationTitle("History")
            .background(Color.cyan.gradient.opacity(0.05))
        }
        
    }
    
    /// UI component for selecting the date whose tracks are shown.
    private var dateSelector: some View {
        DatePicker("Date",
                   selection: $vm.selectedDate,
                   displayedComponents: [.date])
        .datePickerStyle(.graphical)
            
    }
}

fileprivate final class PreviewModel: TrackHistoryViewModelProtocol {
    @Published var selectedDate: Date = .now
    
    @Published var tracks: [Track] = []
    
    func deleteDestinations(_ indexSet: IndexSet) {
        
    }
    init() {
        self.tracks.append(.filledTrack)
    }
    
}

private actor TestCache: TrackMapSnippetCacheProtocol {
    func getSnippet(for track: Track, size: CGSize) async -> UIImage? {
        return nil
    }
    
    func cacheSnippet(_ snippet: UIImage, for track: Track, size: CGSize) async {
    }
}




#Preview {
    TrackHistoryView(vm: PreviewModel(),
                     mapSnapshotGenerator: MapSnapshotGenerator(),
                     mapSnippetCache: TestCache()
    )
}
