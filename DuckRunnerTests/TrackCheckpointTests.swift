//
//  TrackCheckpointTests.swift
//  DuckRunnerTests
//
//  Created by vladukha on 19.02.2026.
//

import Testing
import CoreLocation
@testable import DuckRunner

struct TrackCheckpointTests {
    typealias TestData = (offset: CLLocationDistance, threshold: CLLocationDistance, shouldPass: Bool)
    
    private func offsetNorth(_ coord: CLLocationCoordinate2D, meters: Double) -> CLLocationCoordinate2D {
        // Approximate meters per degree latitude is ~111,320m
        let deltaLat = meters / 111_320.0
        return CLLocationCoordinate2D(latitude: coord.latitude + deltaLat, longitude: coord.longitude)
    }

    @Test("Checkpoint passing validation", arguments: [
        TestData(offset: 0, threshold: 50, shouldPass: true),
        TestData(offset: 15, threshold: 50, shouldPass: true),
        TestData(offset: 20, threshold: 50, shouldPass: true),
        TestData(offset: 50, threshold: 50, shouldPass: true),
        TestData(offset: 49, threshold: 50, shouldPass: true),
        TestData(offset: 55, threshold: 50, shouldPass: false),
        TestData(offset: 51, threshold: 50, shouldPass: false),
        TestData(offset: 55, threshold: 50, shouldPass: false),
        TestData(offset: 60, threshold: 50, shouldPass: false)
    ])
    func testCheckpointPassing(_ data: TestData) async throws {
        let checkpointCoordinate = CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)
        let checkPoint = await TrackCheckPoint(point: .init(position: checkpointCoordinate,
                                                      speed: 0, date: .now),
                                               distanceThreshold: data.threshold)
        let newPoint = await TrackPoint(position: offsetNorth(checkpointCoordinate, meters: data.offset),
                                        speed: 0,
                                        date: .now)
        
        #expect(checkPoint.isPointInCheckpoint(newPoint.position) == data.shouldPass)
        
    }

}
