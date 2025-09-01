//
//  FillGapDatamanager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import Combine

class FillGapDataManager {
    private let firestoreManager = FillGapFirestoreManager()
    
    func fetchFillGapById(_ id: String) -> AnyPublisher<FillGap, Error> {
        return firestoreManager.fetchFillGapById(id)
    }
}
