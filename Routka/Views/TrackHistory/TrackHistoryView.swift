//
//  TrackHistoryView.swift
//  Routka
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import Combine

/// Root view for displaying the user's track history with date-based navigation and detail view links.
struct TrackHistoryView<ViewModel: TrackHistoryViewModelProtocol>: View {
    /// The view model managing and providing track history data and selection.
    @StateObject private var vm: ViewModel
    /// User's preferred unit for speed display, persisted locally.
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    
    private let dependencies: DependencyManager
    
    /// Initializes the history view with the given view model.
    init(vm: ViewModel,
         dependencies: DependencyManager) {
        self._vm = StateObject(wrappedValue: vm)
        self.dependencies = dependencies
    }
    
    /// The main UI displaying history list, navigation links, and date selector.
    var body: some View {
        ScrollView {
            VStack {
                dateSelector
                Divider()
                LazyVStack(spacing: 15) {
                    ForEach(vm.tracks, id: \.id) { track in
                        Button {
                            dependencies.routers[dependencies.tabRouter.selectedTab]?.push(
                                .trackDetail(track: track, dependencies: dependencies))
                        } label: {
                            TrackHistoryCellView(track: track,
                                                 unit: UnitSpeed.byName(speedUnit),
                                                 dependencies: dependencies)
                        }
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .animation(.default, value: vm.tracks.isEmpty)
        .navigationTitle("History")
        .background {
            if vm.tracks.isEmpty {
                emptyTag
            }
        }
        .background(Color.cyan.gradient.opacity(0.05))
    }
    
    private var emptyTag: some View {
        Text("Empty history")
            .font(.largeTitle)
            .opacity(0.6)
            .transition(.opacity)
            .multilineTextAlignment(.center)
    }
    
    /// UI component for selecting the date whose tracks are shown.
    private var dateSelector: some View {
        DatePicker("Date",
                   selection: $vm.selectedDate,
                   displayedComponents: [.date])
        .datePickerStyle(.compact)
            
    }
}

fileprivate final class PreviewModel: TrackHistoryViewModelProtocol {
    @Published var selectedDate: Date = .now
    
    @Published var tracks: [Track] = []
    
    func deleteDestinations(_ indexSet: IndexSet) {
        
    }
    init() {
        self.tracks.append(.newFilledTrack())
        self.tracks.append(.newFilledTrack())
        self.tracks.append(.newFilledTrack())
        self.tracks.append(.newFilledTrack())
        self.tracks.append(.newFilledTrack())
    }
    
}




#Preview {
    TrackHistoryView(vm: PreviewModel(),
                     dependencies: .mock()
    )
}
