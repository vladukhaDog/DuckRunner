//
//  SpeedConverterTests.swift
//  DuckRunnerTests
//
//  Created by vladukha on 15.02.2026.
//

import Testing
@testable import DuckRunner
internal import Foundation


@Suite("SpeedConverter Tests")
struct SpeedConverterTests {
    typealias TestData = (input: Double, mph: Int, kmh: Int)

    @Test("Test Convertion to MPH and kmh", arguments: [
        (31, 69, 112),
        (1, 2, 4),
        (5, 11, 18),
        (100, 224, 360),
        (0, 0, 0),
        (-50, -112, -180),
    ])
    func test_convertion(_ expectationData: TestData) async throws {
        let speedConverter = await SpeedConverter(speed: expectationData.input)
        #expect(speedConverter.getSpeed(.milesPerHour) == expectationData.mph)
        #expect(speedConverter.getSpeed(.kilometersPerHour) == expectationData.kmh)
    }

}
