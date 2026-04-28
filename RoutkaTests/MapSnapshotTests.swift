//
//  MapSnapshotTests.swift
//  RoutkaTests
//
//  Created by vladukha on 18.02.2026.
//

import Testing
@testable import Routka
internal import MapKit

struct MapSnapshotTests {
    /*
     With VPN, Apple maps may not load correctly thus throwing Error Domain=MKErrorDomain Code=2 "(null)
     */

    @Test func testImageGeneration() async throws {
        let mapSnapshotClass = await MapSnapshotGenerator()
        let uiimage = try await mapSnapshotClass.generateSnapshot(track: .filledTrack,
                                                                  size: .init(width: 650, height: 200))
        #expect(uiimage != nil)
    }

}
