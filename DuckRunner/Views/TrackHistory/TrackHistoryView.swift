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
    
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View {
        List {
            Section("History") {
                ForEach(vm.tracks, id: \.startDate) { track in
                    Text(track.startDate.description)
                }
                .onDelete(perform: vm.deleteDestinations)
            }
            
        }
        .frame(maxWidth: .infinity)
        .overlay {
            if vm.tracks.isEmpty {
                Text("Empty history")
                    .font(.largeTitle)
                    .opacity(0.6)
                    .transition(.opacity)
            }
        }
        .animation(.default, value: vm.tracks.isEmpty)
    }
}

//private struct PreviewView: View {
//    @Environment(\.modelContext) var modelContext
//    var body: some View {
//        VStack {
//            Button("Add Test") {
//                modelContext.insert(TrackDTO(track: Track(startDate: .now)))
//            }
//            TrackHistoryView()
//        }
//    }
//}
//
//#Preview("List with data") {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: TrackDTO.self, configurations: config)
//
//        let example = TrackDTO(track: Track(startDate: .now))
//        container.mainContext.insert(example)
//        return TrackHistoryView()
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container.")
//    }
//}
//
//#Preview("List without data") {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: TrackDTO.self, configurations: config)
//        return TrackHistoryView()
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container.")
//    }
//}
