//
//  PuzzleDataManager.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 19/9/24.
//

import Foundation
import Combine
import FirebaseFirestore

class PuzzleDataManager {
    
    private let firestoreManager = PuzzleFirestoreManager()
    
    func fetchPuzzleById(_ id: String) -> AnyPublisher<Puzzle, Error> {
        return firestoreManager.fetchPuzzleById(id)
    }
}
