//
//  Event+Firebase.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import Foundation
import FirebaseFirestore

extension EventModel {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let address = firestoreData["address"] as? String,
              let country = firestoreData["country"] as? String,
              let countrycode = firestoreData["countrycode"] as? String,
              let documentDescription = firestoreData["documentDescription"] as? String,
              let documentName = firestoreData["documentName"] as? String,
              let eventEndDate = firestoreData["eventEndDate"] as? String,
              let eventStartDate = firestoreData["eventStartDate"] as? String,
              let latwgs84String = firestoreData["latwgs84"] as? String,
              let lonwgs84String = firestoreData["lonwgs84"] as? String,
              let physicalUrl = firestoreData["physicalUrl"] as? String,
              let latwgs84 = Double(latwgs84String),
              let lonwgs84 = Double(lonwgs84String) else {
            return nil
        }

        self.id = id
        self.address = address
        self.country = country
        self.countrycode = countrycode
        self.documentDescription = documentDescription
        self.documentName = documentName
        self.eventEndDate = eventEndDate
        self.eventStartDate = eventStartDate
        self.latwgs84 = latwgs84
        self.lonwgs84 = lonwgs84
        self.physicalUrl = physicalUrl
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "address": address,
            "country": country,
            "countrycode": countrycode,
            "documentDescription": documentDescription,
            "documentName": documentName,
            "eventEndDate": eventEndDate,
            "eventStartDate": eventStartDate,
            "latwgs84": String(latwgs84),
            "lonwgs84": String(lonwgs84),
            "physicalUrl": physicalUrl
        ]
    }
}
