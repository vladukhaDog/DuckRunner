//
//  TrackReplayValidator.swift
//  DuckRunner
//
//  Created by vladukha on 19.02.2026.
//

import Foundation
import CoreLocation


/// Coordinates validation of a user's replayed route against a recorded track.
///
/// `TrackReplayValidator` builds a series of geo-spatial checkpoints along a given
/// recorded ``Track`` and then evaluates incoming location samples to determine
/// whether those checkpoints have been passed. The validator is an `actor`, which
/// means its mutable state (like the `checkpoints` dictionary) is protected by
/// actor isolation and is safe to use from concurrent code.
///
/// Checkpoints are created along the polyline of the original track at a fixed
/// distance interval (by default every 500 meters). As the user moves and the
/// app feeds points to the validator via ``passedPoint(_:)``, the validator will
/// mark checkpoints as passed when the user's position falls within the
/// checkpoint's acceptance radius. Completion can be queried as a fraction in
/// the range 0.0–1.0 using `trackCompletionByCheckpoints()`.
final actor TrackReplayValidator {
    
    /// All generated checkpoints keyed by their stable identifier.
    /// - Note: This property is `private(set)` and actor-isolated. Read access
    ///   is allowed from outside the actor via `await`, but mutation is restricted
    ///   to the actor's methods.
    private(set) var checkpoints: [UUID: TrackCheckPoint] = [:]
    
    /// Track which is being replayed
    private let track: Track
    
    /// Creates a validator for a recorded track and generates periodic checkpoints.
    ///
    /// The validator walks the polyline defined by `replayingTrack.points` and
    /// places checkpoints at fixed distance intervals starting from the first
    /// segment after the start point (the start itself is not turned into a
    /// checkpoint as it is typically handled elsewhere).
    ///
    /// - Parameters:
    ///   - replayingTrack: The original track to validate against.
    ///   - checkPointInterval: Distance in meters between checkpoints along the track.
    init(replayingTrack: Track, checkPointInterval: CLLocationDistance = 500) {
        self.track = replayingTrack

        // Build checkpoints every 500 meters starting at the first point
        let points = replayingTrack.points
        // Guard for at least one point
        guard let firstPoint = points.first else { return }

        // Helper to compute distance between two coordinates
        func distance(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> CLLocationDistance {
            let la = CLLocation(latitude: a.latitude, longitude: a.longitude)
            let lb = CLLocation(latitude: b.latitude, longitude: b.longitude)
            return la.distance(from: lb)
        }

        let interval: CLLocationDistance = checkPointInterval // meters
        var nextThreshold: CLLocationDistance = 0 // create at 0m and then every 500m
        var accumulated: CLLocationDistance = 0

        // DO NOT CREATE POINT AT 0 METERS, ITS A START POINT HANDLED ELSEWHERE
        var lastCoord = firstPoint.position
//        let firstCheckpoint = TrackCheckPoint(point: firstPoint)
//        checkpoints[firstCheckpoint.id] = firstCheckpoint
        nextThreshold += interval

        // Walk through subsequent points accumulating distance and placing checkpoints when thresholds are crossed
        for p in points.dropFirst() {
            let coord = p.position
            accumulated += distance(lastCoord, coord)
            // Place as many checkpoints as thresholds crossed since last point
            if accumulated >= nextThreshold {
                let cp = TrackCheckPoint(point: p)
                checkpoints[cp.id] = cp
                nextThreshold += interval
            }
            lastCoord = coord
        }
    }
    
    /// Registers that the user passed near a given point along the replayed path.
    ///
    /// Call this method with the user's current `TrackPoint` as they move. The
    /// validator will evaluate the point against all not-yet-passed checkpoints
    /// and mark any checkpoint as passed if the point lies within its bounds.
    ///
    /// - Parameter point: The latest user location sample expressed as a `TrackPoint`.
    func passedPoint(_ point: TrackPoint) async {
        let checkpointsToCheck = checkpoints.map({$0.value})
        let coordinate = point.position
        var isPassed = false
        for checkpoint in checkpointsToCheck where checkpoint.checkPointPassed == false {
            isPassed = checkpoint.isPointInCheckpoint(coordinate)
            if isPassed {
                self.checkpoints[checkpoint.id]?.setCheckpointPassing(to: isPassed)
            }
        }
        print("aa \(isPassed)")
    }
    
    /// Returns overall completion based on passed checkpoints.
    ///
    /// The value is the ratio of passed checkpoints to total checkpoints and is
    /// clamped to the range 0.0–1.0, where 0.0 means no checkpoints have been
    /// passed and 1.0 means all checkpoints have been passed.
    ///
    /// - Returns: A `Double` in 0.0–1.0 representing completion.
    func trackCompletionByCheckpoints() async -> Double {
        let total = checkpoints.count
//        if total == 0 { return 0 }
//        // Collecting checkpoint passing using taskgroup because isPassed protected by actor isolation
//        let passStates: [Bool] = await withTaskGroup(of: Bool.self) { group in
//            for (_, checkpoint) in checkpoints {
//                group.addTask {
//                    await checkpoint.checkPointPassed
//                }
//            }
//            var results: [Bool] = []
//            results.reserveCapacity(total)
//            for await value in group {
//                results.append(value)
//            }
//            return results
//        }
//        let passedCheckpoints = passStates.filter { $0 }.count
        let passedCheckpoints = checkpoints.count(where: {$0.value.checkPointPassed})
        let percent: Double = Double(passedCheckpoints) / Double(total)
        return max(0.0, min(1.0, percent))
    }
    
}

