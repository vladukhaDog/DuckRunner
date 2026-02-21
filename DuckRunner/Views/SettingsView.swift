//
//  SettingsView.swift
//  DuckRunner
//
//  Created by vladukha on 21.02.2026.
//

import SwiftUI
import CoreLocation

struct SettingsView: View {
    var settings = SettingsService.shared
    
    var body: some View {
        Form {
            Section(header: Text("Replay Completion Threshold")) {
                TextField("Replay Completion Threshold", text: Binding(
                    get: { String(settings.replayCompletionThreshold) },
                    set: { settings.replayCompletionThreshold = Double($0) ?? settings.replayCompletionThreshold }
                ))
                .keyboardType(.decimalPad)
            }
            Section(header: Text("Speed To Auto Start Replay")) {
                TextField("Speed To Auto Start Replay", text: Binding(
                    get: { String(settings.speedToAutoStartReplay) },
                    set: { settings.speedToAutoStartReplay = CLLocationSpeed(Double($0) ?? Double(settings.speedToAutoStartReplay)) }
                ))
                .keyboardType(.decimalPad)
            }
            
            Section(header: Text("Checkpoint Distance Activate Threshold")) {
                TextField("Checkpoint Distance Activate Threshold", text: Binding(
                    get: { String(settings.checkpointDistanceActivateThreshold) },
                    set: { settings.checkpointDistanceActivateThreshold = CLLocationDistance(Double($0) ?? Double(settings.checkpointDistanceActivateThreshold)) }
                ))
                .keyboardType(.decimalPad)
                
                
            }
            
            Section(header: Text("Checkpoint Distance Interval")) {
                TextField("Checkpoint Distance Interval", text: Binding(
                    get: { String(settings.checkpointDistanceInterval) },
                    set: { settings.checkpointDistanceInterval = CLLocationDistance(Double($0) ?? Double(settings.checkpointDistanceInterval)) }
                ))
                .keyboardType(.decimalPad)
                
                
            }
            
            
        }
    }
}

#Preview {
    SettingsView()
}
