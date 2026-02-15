import Testing
internal import Foundation
internal import Combine
import CoreLocation
import MapKit
@testable import DuckRunner

// MARK: - Mocks

final class MockTrackService: TrackServiceProtocol {
    
    var currentTrack: CurrentValueSubject<DuckRunner.Track?, Never> = .init(nil)
    
    private(set) var isActive = false

    func startTrack(at date: Date) {
        isActive = true
        let new = Track(points: [], startDate: date)
        currentTrack.send(new)
    }

    func stopTrack(at date: Date) throws(TrackServiceError) {
        if currentTrack.value == nil {
            throw TrackServiceError.noCurrentTrack
        } else if isActive == false {
            throw TrackServiceError.currentTrackIsFinished
        } else {
            isActive = false
            var updatedTrack = currentTrack.value
            updatedTrack?.stopDate = date
            currentTrack.send(updatedTrack)
        }
    }

    func appendTrackPosition(_ point: DuckRunner.TrackPoint) throws(DuckRunner.TrackServiceError) {
        guard isActive, var track = currentTrack.value else { return }
        track.points.append(point)
        currentTrack.send(track)
    }
}

final class MockLocationService: LocationServiceProtocol {
    var location: PassthroughSubject<CLLocation, Never> = .init()
}

// MARK: - Await helpers

private func awaitNextValue<P: Publisher>(_ publisher: P) async -> P.Output {
    var cancellable: AnyCancellable?
    let stream = AsyncStream<P.Output> { continuation in
        cancellable = publisher.sink { _ in } receiveValue: { value in
            continuation.yield(value)
            continuation.finish()
        }
    }
    let next = await stream.first { _ in true }!
    _ = cancellable // keep alive
    return next
}

// MARK: - Helpers

private func makeLocation(lat: Double = 37.3317, lon: Double = -122.0301, speed: CLLocationSpeed = 0) -> CLLocation {
    return CLLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                      altitude: 0,
                      horizontalAccuracy: 1,
                      verticalAccuracy: 1,
                      course: 0,
                      speed: speed,
                      timestamp: Date())
}

@Suite("BaseMapViewModel Tests")
struct BaseMapViewModelTests {
    @Test("Updating location should add a new point to the track")
    func testProvidingLocationUpdatesTrackInfo() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        // Start a track to allow appending
        await vm.startTrack()
        // Send one location
        await locationService.location.send(makeLocation(speed: 3.0))

        let track = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        let unwrapped = try #require(track)
        #expect(unwrapped.points.count == 1)
    }

    @Test("Updating location should update tracking speed")
    func testProvidingLocationUpdatesCurrentSpeed() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        await vm.startTrack()
        await locationService.location.send(makeLocation(speed: 5.5))

        let speed = await awaitNextValue(vm.$currentSpeed.eraseToAnyPublisher())
        let unwrapped = try #require(speed)
        #expect(unwrapped == 5.5)
    }

    @Test("Starting action should start a new track")
    func testUpdatingTrackServiceCurrentTrackPropagates() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        let start = Date()
        await trackService.startTrack(at: start)

        let trackOpt = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        let track = try #require(trackOpt)
        #expect(track.startDate == start)
        #expect(track.points.isEmpty)
    }

    @Test("Starting Track should clear prev track")
    func testStartTrackStartsTrackBothClearAndAfterAnother() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        await vm.startTrack()
        let firstOpt = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        let first = try #require(firstOpt)

        // Append a point, then start again to replace
        await locationService.location.send(makeLocation(speed: 1.0))
        _ = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        await #expect((vm.currentTrack?.points.count ?? 0) == 1)

        // Start again
        await vm.startTrack()
        let secondOpt = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        let second = try #require(secondOpt)

        #expect(second.startDate >= first.startDate)
        #expect(second.points.isEmpty)
    }
    
    @Test("Start action should work")
    func testStart() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        // Start then stop
        await vm.startTrack()
        let startedTrack = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        await #expect(startedTrack?.stopDate == nil)
        await #expect(startedTrack?.startDate != nil)
    }

    @Test("Stop action on non-existing track is a no-op")
    func testStopNonStartedError() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        // Stopping without starting should throw
        do {
            try await vm.stopTrack()
            Issue.record("Should have thorwn")
        } catch TrackServiceError.noCurrentTrack {
            #expect(true)
        } catch {
            Issue.record("Wrong error")
        }


    }
    
    @Test("After error stop action, start should works")
    func testStartWorksAfterBadStart() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        // Stopping without starting should throw
        do {
            try await vm.stopTrack()
            Issue.record("Should have thorwn")
        } catch TrackServiceError.noCurrentTrack {
            #expect(true)
        } catch {
            Issue.record("Wrong error")
        }

        // Start then stop
        await vm.startTrack()
        let startedTrack = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        await #expect(startedTrack?.stopDate == nil)
        await #expect(startedTrack?.startDate != nil)
        try await vm.stopTrack()
        
        let stoppedTrack = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        await #expect(stoppedTrack?.stopDate != nil)
    }
    
    @Test("Stop Action should throw if called twice")
    func testSecondStopThrowsError() async throws {
        let trackService = MockTrackService()
        let locationService = MockLocationService()
        let vm = await BaseMapViewModel(trackService: trackService, locationService: locationService)

        // Start then stop
        await vm.startTrack()
        let startedTrack = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        await #expect(startedTrack?.stopDate == nil)
        await #expect(startedTrack?.startDate != nil)
        try await vm.stopTrack()
        
        let stoppedTrack = await awaitNextValue(vm.$currentTrack.eraseToAnyPublisher())
        await #expect(stoppedTrack?.stopDate != nil)
        
        // Already stopped track should throw
        do {
            try await vm.stopTrack()
            Issue.record("Should have thrown")
        } catch TrackServiceError.currentTrackIsFinished {
            #expect(true)
        } catch {
            Issue.record("Wrong error")
        }

    }
}

