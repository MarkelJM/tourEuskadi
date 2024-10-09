//
//  TakePhotoDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import Combine

class TakePhotoDataManager {
    private let firestoreManager = TakePhotoFirestoreManager()
    
    func fetchTakePhotoById(_ id: String) -> AnyPublisher<TakePhoto, Error> {
        return firestoreManager.fetchTakePhotoById(id)
    }
}
