//
//  Spot.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation

struct Spot: Identifiable, Codable {
    var id: String
    var abstract: String
    var activityID: String
    var activityType: String
    var coordinates: Coordinates
    var image: String
    var isCompleted: Bool
    var name: String
    var province: String
    var title: String
    var challenge: String
}
