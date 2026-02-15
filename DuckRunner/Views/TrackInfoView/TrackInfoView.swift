//
//  TrackInfoView.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import Combine
internal import _LocationEssentials

struct TrackInfoView<ViewModel: TrackControllerProtocol>: View {
    @ObservedObject private var vm: ViewModel
    private let unitSpeed: UnitSpeed
    init(vm: ViewModel, unit: UnitSpeed) {
        self._vm = .init(wrappedValue: vm)
        self.unitSpeed = unit
    }
    
    var body: some View {
        VStack {
            EmptyView()
            if let track = vm.currentTrack {
                
                EqualFillHStack {
                    TrackTimeView(startDate: track.startDate,
                                  stopDate: track.stopDate)
                    let speed = track.points.topSpeed() ?? 0
                    TrackTopSpeedView(speed,
                                      displayUnit: unitSpeed)
                    let distance = track.points.totalDistance()
                    TrackDistanceView(distance: distance,
                                      unit: unitSpeed.unitLength)
                }
                
                .padding()
                .frame(maxWidth: .infinity)
                .glassEffect(in: RoundedRectangle(cornerRadius: 30))
            }
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
        .padding(10)
        .animation(.bouncy, value: vm.currentTrack?.stopDate == nil)
        .animation(.bouncy, value: vm.currentTrack == nil)
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
              speed: 33),
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33),
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33),
        .init(position: .init(latitude: 30.0,
                              longitude: 30.0),
              speed: 33),
    ], startDate: Date())
    
    func startTrack() {
        self.currentTrack = .init(points: [
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33),
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33),
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33),
            .init(position: .init(latitude: 30.0,
                                  longitude: 30.0),
                  speed: 33),
        ], startDate: Date())
    }
    
    func stopTrack() {
        self.currentTrack?.stopDate = .now
    }
    
}

#Preview {
    ZStack {
        Color.cyan.opacity(0.4)
//        BaseMapView(trackService: TrackService(), locationService: LocationService())
        TrackInfoView(vm: PreviewModel(), unit: .kilometersPerHour)
    }
}
