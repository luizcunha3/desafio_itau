//
//  LocationHelper.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 15/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class LocationHelper {
    static func appleLocationToLatLong(_ location: CLLocation) -> (latitude: Double, longitude: Double) {
        return (location.coordinate.latitude, location.coordinate.longitude)
    }
}
