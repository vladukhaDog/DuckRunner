//
//  ImportedTracksListView.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//
import SwiftUI
import Combine

struct ImportedTracksListView: View {
    @State private var vm: any ImportedTracksListViewModelProtocol
    private let dependencies: DependencyManager
    @AppStorage("speedunit") var speedUnit: String = "km/h"

    init(vm: any ImportedTracksListViewModelProtocol,
         dependencies: DependencyManager) {
        _vm = .init(wrappedValue: vm)
        self.dependencies = dependencies
    }

    var body: some View {
        ScrollView {
            VStack {
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
        .navigationTitle("Imported Tracks")
        .background {
            if vm.tracks.isEmpty {
                emptyTag
            }
        }
        .background(Color.cyan.gradient.opacity(0.05))
    }
    
    private var emptyTag: some View {
        VStack(spacing: 20) {
            
            Text("You have no imported tracks.")
                .font(.largeTitle)
                .opacity(0.6)
                .transition(.opacity)
                .multilineTextAlignment(.center)
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Import from files")
                }
                .font(.title2)
            }
        }
    }
}

/// Preview model for ImportedTracksListView
@Observable
private final class PreviewImportedModel: ImportedTracksListViewModelProtocol {
    var tracks: [Track] = [
//        .filledTrack,
//        .filledTrack,
//        .filledTrack
    ]
}

#Preview {
    NavigationView {
        ImportedTracksListView(vm: PreviewImportedModel(), dependencies: .mock())
    }
}
