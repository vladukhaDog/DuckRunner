//
//  SettingsView.swift
//  Routka
//
//  Created by vladukha on 21.02.2026.
//

import SwiftUI
import CoreLocation
import NeedleFoundation

// MARK: - List of dependencies
protocol SettingsDependency: Dependency {
    var cacheFileManager: any CacheFileManagerProtocol { get }
    var mapSnippetCache: any TrackMapSnippetCacheProtocol { get }
}

// MARK: - Main Component creation
nonisolated
final class SettingsComponent: Component<SettingsDependency> {

    @MainActor
    var view: SettingsView {
        SettingsView(cacheFileManager: dependency.cacheFileManager,
                     mapSnippetCache: dependency.mapSnippetCache)
    }
}

// MARK: - View
struct SettingsView: View {
    var cacheFileManager: any CacheFileManagerProtocol
    var mapSnippetCache: any TrackMapSnippetCacheProtocol
    var settings = SettingsService.shared

    @AppStorage("speedunit") var speedUnit: String = "km/h"
    @State private var storageInfo = StorageInfo(availableSpaceBytes: 0, tmpFolderSizeBytes: 0, tmpFolderFileCount: 0)
    @State private var isClearingCache = false

    private var freeSpaceText: String {
        Self.byteFormatter.string(fromByteCount: storageInfo.availableSpaceBytes)
    }

    private var usedSpaceText: String {
        Self.byteFormatter.string(fromByteCount: storageInfo.tmpFolderSizeBytes)
    }

    private var cacheUsageProgress: Double {
        let used = Double(storageInfo.tmpFolderSizeBytes)
        let total = used + Double(storageInfo.availableSpaceBytes)
        guard total > 0 else { return 0 }
        return min(max(used / total, 0), 1)
    }

    var body: some View {
        Form {
//            Section(header: Text("Replay Completion Threshold")) {
//                TextField("Replay Completion Threshold", text: Binding(
//                    get: { String(settings.replayCompletionThreshold) },
//                    set: { settings.replayCompletionThreshold = Double($0) ?? settings.replayCompletionThreshold }
//                ))
//                .keyboardType(.decimalPad)
//            }
//            Section(header: Text("Speed To Auto Start Replay")) {
//                TextField("Speed To Auto Start Replay", text: Binding(
//                    get: { String(settings.speedToAutoStartReplay) },
//                    set: { settings.speedToAutoStartReplay = CLLocationSpeed(Double($0) ?? Double(settings.speedToAutoStartReplay)) }
//                ))
//                .keyboardType(.decimalPad)
//            }
//
//            Section(header: Text("Checkpoint Distance Activate Threshold")) {
//                TextField("Checkpoint Distance Activate Threshold", text: Binding(
//                    get: { String(settings.checkpointDistanceActivateThreshold) },
//                    set: { settings.checkpointDistanceActivateThreshold = CLLocationDistance(Double($0) ?? Double(settings.checkpointDistanceActivateThreshold)) }
//                ))
//                .keyboardType(.decimalPad)
//            }
//
//            Section(header: Text("Checkpoint Distance Interval")) {
//                TextField("Checkpoint Distance Interval", text: Binding(
//                    get: { String(settings.checkpointDistanceInterval) },
//                    set: { settings.checkpointDistanceInterval = CLLocationDistance(Double($0) ?? Double(settings.checkpointDistanceInterval)) }
//                ))
//                .keyboardType(.decimalPad)
//            }

            Section("Storage") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        storageMetric(title: "Available", value: freeSpaceText, tint: .green)
                        storageMetric(title: "Cache", value: usedSpaceText, tint: .orange)
                    }

                    ProgressView(value: cacheUsageProgress)
                        .tint(.orange)

                    HStack {
                        Text("\(storageInfo.tmpFolderFileCount) files in temporary folder")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Button {
                            Task {
                                await clearCacheAndReloadStorageInfo()
                            }
                        } label: {
                            if isClearingCache {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .foregroundStyle(Color.white)
                        .disabled(isClearingCache)
                        .opacity(storageInfo.tmpFolderFileCount == 0 ? 0 : 1)
                    }
                }
            }
            Picker("Speed measure", selection: $speedUnit) {
                ForEach(["km/h", "mph", "m/s"], id: \.self) { unit in
                    Text(unit)
                        .tag(unit)
                }
            }
        }
        .task {
            await refreshStorageInfo()
        }
        .animation(.bouncy, value: storageInfo.tmpFolderFileCount)
    }

    private func storageMetric(title: LocalizedStringKey, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.14))
        )
        .animation(.default, value: value)
    }

    private func clearCacheAndReloadStorageInfo() async {
        guard !isClearingCache else { return }
        isClearingCache = true
        defer { isClearingCache = false }

        await mapSnippetCache.removeAllCacheFiles()
        await refreshStorageInfo()
    }

    private func refreshStorageInfo() async {
        storageInfo = await cacheFileManager.storageInfo()
    }

    private static let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB, .useTB]
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        return formatter
    }()
}

#Preview {
    SettingsView(cacheFileManager: DependencyManager.MockCacheFileManager(),
                 mapSnippetCache: DependencyManager.MockTrackMapSnippetCache())
}
