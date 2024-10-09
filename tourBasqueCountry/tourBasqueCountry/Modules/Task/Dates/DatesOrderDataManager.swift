//
//  DatesOrderDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import Combine

class DatesOrderDataManager {
    private let firestoreManager = DatesOrderFirestoreManager()
    
    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        return firestoreManager.fetchDateEventById(id)
    }
}
