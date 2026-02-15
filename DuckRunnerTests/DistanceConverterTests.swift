//
//  DistanceConverterTests.swift
//  DuckRunnerTests
//
//  Created by Assistant on 16.02.2026.
//

import Testing
@testable import DuckRunner
internal import Foundation

// input in meters, expected miles and kilometers (rounded ints)
typealias DistanceTestData = (inputMeters: Double, miles: Int, kilometers: Int)

@Suite("DistanceConverter Tests")
struct DistanceConverterTests {

    @Test("Test Conversion to miles and kilometers", arguments: [
        (0.0,       0, 0),
        (1.0,       0, 0),
        (100.0,     0, 0),
        (1000.0,    0, 1),
        (1609.34,   3, 5),
        (5000.0,    26, 42),
        (42195.0,   62, 100),
        (100000.0,  0, -1),
        (-1000.0,   0, 0),
    ])
    func test_conversion(_ expectationData: DistanceTestData) async throws {
        let converter = await DistanceConverter(distance: expectationData.inputMeters)
        #expect(Int(converter.getDistance(.miles)) == expectationData.miles)
        #expect(Int(converter.getDistance(.kilometers)) == expectationData.kilometers)
    }
}
