//
//  Event.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import Foundation

struct EventModel: Identifiable {
    var id: String
    var address: String
    var country: String
    var countrycode: String
    var documentDescription: String
    var documentName: String
    var eventEndDate: String
    var eventStartDate: String
    var latwgs84: Double
    var lonwgs84: Double
    var physicalUrl: String
}
