import SwiftUI

protocol TrackPresetsViewModelProtocol: Observable {
    /// Start recording with the provided measurement policy
    func startTrack(_ mode: RecordingAutoStopPolicy)
    
    var presets: [(preset: RecordingAutoStopPolicy, time: TimeInterval?)] { get }
//
//    /// Fetch and return the shortest measured track for the given preset names
//    func getShortestHalfMile() async -> MeasuredTrack?
//    func getShortestQuarterMile() async -> MeasuredTrack?
//    func getShortestZeroToHundred() async -> MeasuredTrack?
//    
}
