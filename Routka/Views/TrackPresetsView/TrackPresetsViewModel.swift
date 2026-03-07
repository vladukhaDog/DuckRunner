import SwiftUI

@Observable
final class TrackPresetsViewModel: TrackPresetsViewModelProtocol {
    static let allPresets: [RecordingAutoStopPolicy] = [
        .reachingDistance(804.672, name: "1/2 mile"),
        .reachingDistance(402.336, name: "1/4 mile"),
        .reachingDistance(201.168, name: "1/8 mile"),
        .reachingSpeed(27.7778, name: "0-100 km/h"),
        .reachingSpeed(16.6667, name: "0-60 km/h")
    ]
    
    var presets: [(preset: RecordingAutoStopPolicy, time: TimeInterval?)] = TrackPresetsViewModel.allPresets.map({($0, nil)})
    
    
    private let baseMapVM: any BaseMapViewModelProtocol
    private let dependencies: DependencyManager

    init(baseMapVM: any BaseMapViewModelProtocol, dependencies: DependencyManager) {
        self.baseMapVM = baseMapVM
        self.dependencies = dependencies
        Task {
            let enumer = presets.enumerated()
            for (index, preset) in enumer {
                guard let track = await dependencies
                    .measuredTrackStorageService
                    .getShortestMeasuredTrack(named: preset.preset.name)?
                    .track else {
                    continue
                }
                let time = (track.stopDate ?? track.startDate).timeIntervalSince(track.startDate)
                withAnimation {
                    self.presets[index].time = time
                }
            }
        }
    }

    func startTrack(_ mode: RecordingAutoStopPolicy) {
        baseMapVM.startTrack(mode)
    }

//    func getShortestHalfMile() async -> MeasuredTrack? {
//        await dependencies.measuredTrackStorageService.getShortestMeasuredTrack(named: "1/2 mile")
//    }
//
//    func getShortestQuarterMile() async -> MeasuredTrack? {
//        await dependencies.measuredTrackStorageService.getShortestMeasuredTrack(named: "1/4 mile")
//    }
//
//    func getShortestZeroToHundred() async -> MeasuredTrack? {
//        await dependencies.measuredTrackStorageService.getShortestMeasuredTrack(named: "0-100 km/h")
//    }
}
