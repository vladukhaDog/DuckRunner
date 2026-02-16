//
//  TrackHistoryView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import Combine

struct TrackHistoryView<ViewModel: TrackHistoryViewModelProtocol>: View {
    @StateObject private var vm: ViewModel
    @AppStorage("speedunit") var speedUnit: String = "km/h"
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
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
                                                 unit: UnitSpeed.byName(speedUnit))
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


#Preview {
    TrackHistoryView(vm: PreviewModel())
}
