//
//  TrackHistoryCellView.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI

/// View Cell of a Track in history list
struct TrackHistoryCellView: View {
    let track: Track
    let unit: UnitSpeed
    let mapSnapshotGenerator: any MapSnapshotGeneratorProtocol
    let mapSnippetCache: any TrackMapSnippetCacheProtocol
    
    /// Initializes the history view with the given view model.
    init(track: Track, unit: UnitSpeed,
         mapSnapshotGenerator: any MapSnapshotGeneratorProtocol,
         mapSnippetCache: any TrackMapSnippetCacheProtocol) {
        self.track = track
        self.unit = unit
        self.mapSnippetCache = mapSnippetCache
        self.mapSnapshotGenerator = mapSnapshotGenerator
    }
    
    var body: some View {
        VStack() {
            HStack {
                date
                Spacer()
                Image(systemName: "chevron.right")
            }
            time
                .frame(maxWidth: .infinity, alignment: .leading)
            mapSnippet
            HStack {
                CompactTrackDistanceView(distance: track.points.totalDistance(),
                                         unit: unit)
                Spacer()
                if let stopDate = track.stopDate {
                    CompactTrackDurationView(startDate: track.startDate,
                                             stopDate: stopDate)
                }
                Spacer()
                if let speed = track.points.topSpeed() {
                    CompactTrackTopSpeedView(speed: speed,
                                             unit: unit)
                }
            }
            
        }
        .foregroundStyle(Color.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassEffect(in: RoundedRectangle(cornerRadius: 15))
        .padding()
    }
    
    private var time: some View {
        Text(track.startDate.toString(format: "EEE HH:mm"))
            .font(.caption)
            .fontWeight(.semibold)
            .opacity(0.7)
    }
    
    private var date: some View {
        let date = track.startDate.toString(style: .medium)
        return Text(date)
            .font(.title2)
            .bold()
    }
    
    @State private var mapSnippetImage: UIImage?
    private var mapSnippet: some View {
        LinearGradient(colors: [.init(white: 0.2), .init(white: 0.1),
            .init(white: 0.15)],
                       startPoint: .topLeading,
                       endPoint: .topTrailing)
            .frame(height: 100)
            .background {
                GeometryReader { geo in
                    Color.clear
                        .task {
                            if let cachedImage = await mapSnippetCache.getSnippet(for: track, size: geo.size) {
                                await MainActor.run {
                                    withAnimation {
                                        self.mapSnippetImage = cachedImage
                                    }
                                }
                            } else {
                                guard let image = try? await mapSnapshotGenerator
                                    .generateSnapshot(track: track, size: geo.size) else {
                                    return
                                }
                                await MainActor.run {
                                    withAnimation {
                                        self.mapSnippetImage = image
                                    }
                                }
                                await mapSnippetCache.cacheSnippet(image,
                                                                   for: track,
                                                                   size: geo.size)
                            }
                        }
                }
            }
            .overlay(content: {
                if let mapSnippetImage {
                    Image(uiImage: mapSnippetImage)
                        .resizable()
                        .scaledToFit()
                }
            })
            .redacted(reason: mapSnippetImage == nil ? .placeholder : [])
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
            .opacity(0.8)
            .disabled(true)
            .allowsHitTesting(false)
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
    ZStack {
//        Color.cyan.opacity(0.3)
        VStack {
            TrackHistoryCellView(track: .filledTrack,
                                 unit: .kilometersPerHour,
                                 mapSnapshotGenerator: MapSnapshotGenerator(),
                                 mapSnippetCache: TestCache())
            TrackHistoryCellView(track: .filledTrack,
                                 unit: .milesPerHour,
                                 mapSnapshotGenerator: MapSnapshotGenerator(),
                                 mapSnippetCache: TestCache())
        }
    }
}
