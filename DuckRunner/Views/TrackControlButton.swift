//
//  TrackControlButton.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import CoreLocation
import Combine

struct TrackControlButton<ViewModel: TrackControllerProtocol>: View {
    @ObservedObject private var vm: ViewModel
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View {
        Group {
            if let track = vm.currentTrack,
               track.stopDate == nil {
                stopBigButton
                    .transition(.asymmetric(insertion: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.1, anchor: .bottom)),
                                            removal: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.1, anchor: .bottom))))
            } else {
                startBigButton
                    .transition(.asymmetric(insertion: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.1, anchor: .bottom)),
                                            removal: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.1, anchor: .bottom))))
            }
        }
        .animation(.bouncy, value: vm.currentTrack?.stopDate)
    }
    
    
    private var startBigButton: some View {
        Button {
            self.vm.startTrack()
        } label: {
            Text("Start")
                .font(.title)
                .bold()
                .foregroundStyle(Color.primary.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity)
        }
        .glassEffect(.regular.tint(.green.opacity(0.5)).interactive(), in: Capsule())
        .id("startbutton")
    }
    
    private var stopBigButton: some View {
        Button {
            try? self.vm.stopTrack()
        } label: {
            Text("Stop")
                .font(.title)
                .bold()
                .foregroundStyle(Color.primary.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity)
        }
        .glassEffect(.regular.tint(.red.opacity(0.5)).interactive(), in: Capsule())
        .id("stopbutton")
    }
}
final private class PreviewModel: TrackControllerProtocol {
    @Published var currentTrack: Track? = .init(points: [
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33, date: .now),
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33, date: .now),
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33, date: .now),
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33, date: .now),
    ], startDate: Date())
    
    func startTrack() {
        self.currentTrack = .init(points: [
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33, date: .now),
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33, date: .now),
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33, date: .now),
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33, date: .now),
        ], startDate: Date())
    }
    
    func stopTrack() {
        self.currentTrack?.stopDate = .now
    }
    
}


#Preview {
    TrackControlButton(vm: PreviewModel())
}
