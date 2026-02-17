//
//  Track.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import CoreLocation
import CoreData


/// Represents a recorded track consisting of multiple location points and timing information.
struct Track: Codable {
    /// Unique identifier for the track.
    let id: String
    /// The sequence of recorded location points that form this track.
    var points: [TrackPoint]
    /// The starting date and time of the track.
    private(set) var startDate: Date
    /// The end date and time of the track, if stopped.
    var stopDate: Date?
    /// Initializes a new Track with provided points and time range.
    init(points: [TrackPoint] = [], startDate: Date, stopDate: Date? = nil) {
        self.points = points
        self.startDate = startDate
        self.stopDate = stopDate
        self.id = UUID().uuidString
    }
}

extension Track {
    /// Conversion initializer for building Track from a Core Data entity.
    init(_ track: TrackDTO) {
        let points: [TrackPoint] = track.points?.allObjects.compactMap({
            if let point = ($0 as? TrackPointDTO) {
                return TrackPoint(point)
            } else {
                return nil
            }
        }) ?? []
        self.points = points
            .sorted(by: {$0.date < $1.date})
        self.startDate = track.startDate ?? .now
        self.stopDate = track.stopDate
        self.id = track.id ?? UUID().uuidString
    }
}

extension TrackPointDTO {
    /// Conversion initializer for creating a Core Data TrackPointDTO from a TrackPoint.
    convenience init(context: NSManagedObjectContext,
                     _ trackPoint: TrackPoint) {
        self.init(context: context)
        self.latitude = trackPoint.position.latitude
        self.longitude = trackPoint.position.longitude
        self.speed = trackPoint.speed
        self.date = trackPoint.date
    }
}

extension TrackDTO {
    /// Conversion initializer for creating a Core Data TrackDTO from a Track.
    convenience init(context: NSManagedObjectContext,
                     _ track: Track) {
        self.init(context: context)
        self.id = track.id
        self.startDate = track.startDate
        self.stopDate = track.stopDate
        self.points = NSSet(array: track.points.map({TrackPointDTO(context: context, $0)}))
    }
}

/// Represents a single recorded point on a track, including location, speed, and timestamp.
struct TrackPoint: Codable {
    /// The geographic coordinate for this track point.
    private(set) var position: CLLocationCoordinate2D
    /// The speed measured at this point.
    private(set) var speed: CLLocationSpeed
    /// The date and time this point was recorded.
    private(set) var date: Date
    /// Initializes a new TrackPoint with the given location, speed, and timestamp.
    init(position: CLLocationCoordinate2D, speed: CLLocationSpeed, date: Date) {
        self.position = position
        self.speed = speed
        self.date = date
    }
}

extension TrackPoint {
    /// Conversion initializer for building TrackPoint from a Core Data entity.
    init(_ trackPoint: TrackPointDTO) {
        self.position = .init(latitude: trackPoint.latitude, longitude: trackPoint.longitude)
        self.speed = trackPoint.speed
        self.date = trackPoint.date ?? Date()
    }
}


extension CLLocationCoordinate2D: @retroactive Codable {
    /// Codable conformance for CLLocationCoordinate2D enabling serialization.
    enum CodingKeys: String, CodingKey {
        case longitude
        case latitude
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
    }
    
    
}



extension Array where Element == TrackPoint {
    /// Convenience extensions for arrays of TrackPoint, providing total distance and top speed calculation.
    
    /// Calculates the total distance covered by the sequence of track points, in meters.
    func totalDistance() -> CLLocationDistance {
        guard self.count > 1 else {
            return 0.0
        }

        var totalDistance: CLLocationDistance = 0.0
        
        for i in 0..<(self.count - 1) {
            let coordinate1 = self[i]
            let coordinate2 = self[i+1]
            
            // Convert CLLocationCoordinate2D to CLLocation to use the distance(from:) method
            let location1 = CLLocation(latitude: coordinate1.position.latitude,
                                       longitude: coordinate1.position.longitude)
            let location2 = CLLocation(latitude: coordinate2.position.latitude,
                                       longitude: coordinate2.position.longitude)
            
            totalDistance += location1.distance(from: location2)
        }
        
        return totalDistance
    }
    
    /// Finds the highest recorded speed among all track points in the array.
    func topSpeedPoint() -> Self.Element? {
        let topSpeed = self
            .max { ls, rs in
                ls.speed < rs.speed
            }
        return topSpeed
    }
    
    func topSpeed() -> CLLocationSpeed? {
        self.topSpeedPoint()?.speed
    }
}

