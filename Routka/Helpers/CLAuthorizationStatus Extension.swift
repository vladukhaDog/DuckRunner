//
//  CLAuthorizationStatus Extension.swift
//  Routka
//
//  Created by vladukha on 25.02.2026.
//

import CoreLocation

extension CLAuthorizationStatus {
        func isAuthorized() -> Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}
