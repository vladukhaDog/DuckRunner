//
//  MapSnapshotTests.swift
//  DuckRunnerTests
//
//  Created by vladukha on 18.02.2026.
//

import Testing
@testable import DuckRunner
internal import MapKit

struct MapSnapshotTests {

    @Test func testImageGeneration() async throws {
        let mapSnapshotClass = await MapSnapshotGenerator()
        let uiimage = try await mapSnapshotClass.generateSnapshot(track: .filledTrack,
                                                                  size: .init(width: 650, height: 200))
        #expect(uiimage != nil)
    }

}
