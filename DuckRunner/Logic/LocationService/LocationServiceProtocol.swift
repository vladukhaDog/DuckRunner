//
//  LocationServiceProtocol.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Combine
import CoreLocation

protocol LocationServiceProtocol {
    var location: PassthroughSubject<CLLocation, Never> { get }
}
