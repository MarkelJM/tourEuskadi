//
//  UserAnnotation.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import CoreLocation

struct UserAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D?
}
