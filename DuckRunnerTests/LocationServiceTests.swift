import Testing
internal import Combine
import CoreLocation
@testable import DuckRunner

// Mock CLLocationManager that allows us to manually call delegate.
final class MockLocationManager: CLLocationManager {
    weak var testDelegate: CLLocationManagerDelegate?
    override var delegate: CLLocationManagerDelegate? {
        get { testDelegate }
        set { testDelegate = newValue }
    }
    func simulateLocation(_ location: CLLocation) {
        testDelegate?.locationManager?(self, didUpdateLocations: [location])
    }
}

@Suite("LocationService Tests")
struct LocationServiceTests {
    @Test("Publishes location when mock location manager sends update")
    func testPublishesLocation() async throws {
        let mockManager = MockLocationManager()
        let locationService = await LocationService(locationManager: mockManager)
        let testLocation = CLLocation(latitude: 51.5074, longitude: -0.1278) // London
        var receivedLocation: CLLocation?
        let cancellable = await locationService.location.sink { loc in
            receivedLocation = loc
        }
        mockManager.simulateLocation(testLocation)
        // Wait briefly for Combine to deliver the value
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        #expect(receivedLocation?.coordinate.latitude == 51.5074)
        #expect(receivedLocation?.coordinate.longitude == -0.1278)
        cancellable.cancel()
    }
}
